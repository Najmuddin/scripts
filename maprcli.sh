#!/bin/bash
# Script to do auto-completion for maprcli command.

# COMPREPLY: an array containing possible completions as a result of your function
# COMP_WORDS: an array containing individual command arguments typed so far
# COMP_CWORD: the index of the command argument containing the current cursor position
# COMP_LINE: the current command line

__maprcli()
  {
  local cur prev opts base
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD -1]}"
  first="${COMP_WORDS[1]}"
  numArgs="${#COMP_WORDS[@]}"
  service_action="start stop suspend resume restart"
  acl_opts="-type -name -cluster -user -group"
  opts="acl alarm blacklist config dashboard  debugdb dialhome disk dump entity job license \
nagios nfsmgmt node rlimit schedule security service setloglevel table task trace urls virtualip volume"

  case "${prev}" in
      acl)
      COMPREPLY=( $(compgen -W "show set edit" -- ${cur}) ) # FIXME add -type & -name
	return 0
	;;
	  set|edit)
	  COMPREPLY=( $(compgen -W "${acl_opts}" -- ${cur}) ) 
	  return 0
	  ;;
	  show)
	  COMPREPLY=( $(compgen -W "${acl_opts} -perm -output" -- ${cur}) )
	  return 0
	  ;;
      alarm)
      COMPREPLY=( $(compgen -W "list raise clear clearall config names" -- ${cur}) )
      return 0
	;;
      blacklist)
      COMPREPLY=( $(compgen -W "user listusers" -- ${cur}) )
      return 0
	;;
      config)
      COMPREPLY=( $(compgen -W "load save" -- ${cur}) )
      return 0
	;;
      dashboard)
      COMPREPLY=( $(compgen -W "info" -- ${cur}) ) # FIXME
      return 0
	;;
      debugdb)
      COMPREPLY=( $(compgen -W "dump dumpTable stat cdscan bmap checkTablet statTablet switchMaster rawScan" -- ${cur}) )
      return 0
	;;
      dialhome)
      COMPREPLY=( $(compgen -W "metrics enable status ackdial lastdialed" -- ${cur}) )
      return 0
	;;
      disk)
      COMPREPLY=( $(compgen -W "list listall add remove" -- ${cur}) )
      return 0
	;;
      dump)
      COMPREPLY=( $(compgen -W "containerinfo containers volumeinfo volumenodes \ 
      replicationmanagerinfo replicationmanagerqueueinfo rereplicationinfo \ 
      rereplicationmetrics balancerinfo balancermetrics rolebalancerinfo \ 
      rolebalancermetrics fileserverworkinfo zkinfo supportdump cldbnodes" -- ${cur}) )
      return 0
	;;
      entity)
      COMPREPLY=( $(compgen -W "list info modify" -- ${cur}) )
      return 0
	;;
      job)
      COMPREPLY=( $(compgen -W "kill changepriority linklogs" -- ${cur}) )
      return 0
	;;
      license)
      COMPREPLY=( $(compgen -W "add remove list apps showid addcrl listcrl" -- ${cur}) )
      return 0
	;;
      nagios)
      COMPREPLY=( $(compgen -W "generate" -- ${cur}) )
      return 0
	;;
      nfsmgmt)
      COMPREPLY=( $(compgen -W "refreshexports" -- ${cur}) )
      return 0
	;;
      node)
      COMPREPLY=( $(compgen -W "list move modify allow-into-cluster services topo remove \
      heatmap listcldbs listzookeepers cldbmaster maintenance metrics listcldbzks" -- ${cur}) )
      return 0
	;;
	  services)
         COMPREPLY=( $(compgen -W "-cluster -filter -zkconnect -nodes -cldb  -fileserver \
	 -hbmaster -hbregionserver -jobtracker -nfs -tasktracker -webserver -name -action" -- ${cur}) )
	 return 0
	  ;;
	  -action|-cldb|-fileserver|-hbmaster|-hbregionserver|-jobtracker|-nfs|-tasktracker|-webserver) 
	  COMPREPLY=( $(compgen -W "${service_action}" -- ${cur}) )
	  return 0
	    ;;	  
      rlimit)
      COMPREPLY=( $(compgen -W "set get" -- ${cur}) )
      return 0
	;;
      schedule)
      COMPREPLY=( $(compgen -W "create modify list remove" -- ${cur}) )
      return 0
	;;
      security)
      COMPREPLY=( $(compgen -W "genkey genticket getmapruserticket" -- ${cur}) )
      return 0
	;;
      service)
      COMPREPLY=( $(compgen -W "list" -- ${cur}) )
      return 0
	;;
      setloglevel)
      COMPREPLY=( $(compgen -W "cldb fileserver nfs jobtracker tasktracker hbmaster hbregionserver" -- ${cur}) )
      return 0
	;;
      table)
      COMPREPLY=( $(compgen -W "create edit delete listrecent info cf region" -- ${cur}) )
      return 0
	;;
      task)
      COMPREPLY=( $(compgen -W "killattempt failattempt" -- ${cur}) )
      return 0
	;;
      trace)
      COMPREPLY=( $(compgen -W "dump setmode setlevel resize reset info print" -- ${cur}) )
      return 0
	;;
      urls)
      COMPREPLY=( $(compgen -W "url" -- ${cur}) ) # FIXME
      return 0
	;;
      virtualip)
      COMPREPLY=( $(compgen -W "add remove edit move list" -- ${cur}) )
      return 0
	;;
      volume)
      COMPREPLY=( $(compgen -W "create modify remove mount unmount list snapshot \
      mirror dump rename move link info showmounts fixmountpath" -- ${cur}) )
      return 0
	;;
    *)
    ;;
    esac

    # complete the following only if current args < 2
  if [ $numArgs -le 2 ] ; then
  COMPREPLY=($(compgen -W "${opts}" -- ${cur})) 
  return 0
  fi
  
  }
  
complete -o bashdefault -o default -F __maprcli maprcli	