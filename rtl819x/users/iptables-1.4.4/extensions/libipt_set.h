#ifndef _LIBIPT_SET_H
#define _LIBIPT_SET_H

#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>

#ifdef DEBUG
#define DEBUGP(x, args...) fprintf(stderr, x, ## args)
#else
#define DEBUGP(x, args...) 
#endif

static void
parse_bindings(const char *opt_arg, struct ipt_set_info *info)
{
	char *saved = strdup(opt_arg);
	char *ptr, *tmp = saved;
	int i = 0;
	
	while (i < (IP_SET_MAX_BINDINGS - 1) && tmp != NULL) {
		ptr = strsep(&tmp, ",");
		if (strncmp(ptr, "src", 3) == 0)
			info->flags[i++] |= IPSET_SRC;
		else if (strncmp(ptr, "dst", 3) == 0)
			info->flags[i++] |= IPSET_DST;
		else
			xtables_error(PARAMETER_PROBLEM,
				   "You must spefify (the comma separated list of) 'src' or 'dst'.");
	}

	if (tmp)
		xtables_error(PARAMETER_PROBLEM,
			   "Can't follow bindings deeper than %i.", 
			   IP_SET_MAX_BINDINGS - 1);

	free(saved);
}

static int get_version(unsigned *version)
{
	int res, sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
	struct ip_set_req_version req_version;
	socklen_t size = sizeof(req_version);
	
	if (sockfd < 0)
		xtables_error(OTHER_PROBLEM,
			   "Can't open socket to ipset.\n");

	req_version.op = IP_SET_OP_VERSION;
	res = getsockopt(sockfd, SOL_IP, SO_IP_SET, &req_version, &size);
	if (res != 0)
		xtables_error(OTHER_PROBLEM,
			   "Kernel module ip_set is not loaded in.\n");

	*version = req_version.version;
	
	return sockfd;
}

static void get_set_byname(const char *setname, struct ipt_set_info *info)
{
	struct ip_set_req_get_set req;
	socklen_t size = sizeof(struct ip_set_req_get_set);
	int res, sockfd;

	sockfd = get_version(&req.version);
	req.op = IP_SET_OP_GET_BYNAME;
	strncpy(req.set.name, setname, IP_SET_MAXNAMELEN);
	req.set.name[IP_SET_MAXNAMELEN - 1] = '\0';
	res = getsockopt(sockfd, SOL_IP, SO_IP_SET, &req, &size);
	close(sockfd);

	if (res != 0)
		xtables_error(OTHER_PROBLEM,
			   "Problem when communicating with ipset, errno=%d.\n",
			   errno);
	if (size != sizeof(struct ip_set_req_get_set))
		xtables_error(OTHER_PROBLEM,
			   "Incorrect return size from kernel during ipset lookup, "
			   "(want %zu, got %zu)\n",
			   sizeof(struct ip_set_req_get_set), (size_t)size);
	if (req.set.index == IP_SET_INVALID_ID)
		xtables_error(PARAMETER_PROBLEM,
			   "Set %s doesn't exist.\n", setname);

	info->index = req.set.index;
}

static void get_set_byid(char * setname, ip_set_id_t idx)
{
	struct ip_set_req_get_set req;
	socklen_t size = sizeof(struct ip_set_req_get_set);
	int res, sockfd;

	sockfd = get_version(&req.version);
	req.op = IP_SET_OP_GET_BYINDEX;
	req.set.index = idx;
	res = getsockopt(sockfd, SOL_IP, SO_IP_SET, &req, &size);
	close(sockfd);

	if (res != 0)
		xtables_error(OTHER_PROBLEM,
			   "Problem when communicating with ipset, errno=%d.\n",
			   errno);
	if (size != sizeof(struct ip_set_req_get_set))
		xtables_error(OTHER_PROBLEM,
			   "Incorrect return size from kernel during ipset lookup, "
			   "(want %zu, got %zu)\n",
			   sizeof(struct ip_set_req_get_set), (size_t)size);
	if (req.set.name[0] == '\0')
		xtables_error(PARAMETER_PROBLEM,
			   "Set id %i in kernel doesn't exist.\n", idx);

	strncpy(setname, req.set.name, IP_SET_MAXNAMELEN);
}

#endif /*_LIBIPT_SET_H*/
