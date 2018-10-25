#!/bin/bash
# TAB auto completion for maprcli.

# COMPREPLY: an array containing possible completions as a result of your function
# COMP_WORDS: an array containing individual command arguments typed so far
# COMP_CWORD: the index of the command argument containing the current cursor position
# COMP_LINE: the current command line

__list_all_nodes() {
      local nodes=$(maprcli node list -columns hn |awk '{print $1}'|tail -n +2)
      COMPREPLY=($(compgen -W "$nodes" -- ${cur}))
  }

__list_cluster(){
      local clusters=$(awk '{print $1}' "/opt/mapr/conf/mapr-clusters.conf")
      COMPREPLY=($(compgen -W "$clusters" -- ${cur}))
}

__node_services(){
      COMPREPLY=( $(compgen -W "-cluster -filter -zkconnect -nodes -cldb  -fileserver \
      -hbmaster -hbregionserver -jobtracker -nfs -tasktracker -webserver -name -action" -- ${cur}) )
}

__maprcli()
  {
  local prev prev2 first numArgs acl_opts base 
  json="-json"
  numArgs="${#COMP_WORDS[@]}"
# Read the current, last and last to last arguments typed by the user.  
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD -1]}"
  if [ $numArgs -gt 2 ] ; then
    prev2="${COMP_WORDS[COMP_CWORD -2]}"
  fi
  first="${COMP_WORDS[1]}"
  second="${COMP_WORDS[2]}"

  service_action="start stop suspend resume restart"
  acl_opts="-type -name -cluster -user -group"
  main_opts="acerole acl alarm audit blacklist cluster config dashboard  debugdb \
    dialhome disk dump entity job license nagios nfsmgmt node rlimit \
    schedule security service setloglevel table task trace urls virtualip volume"

 config_load_keys="bulk.container.create.support cldb.accept.unknown.replica.delay.mins cldb.acr.threadpool.backlog \
    cldb.active.writer.purge.interval.sec cldb.active.writer.threshold cldb.assigncache.inactivity.threshold \
    cldb.auto.compaction.frequency.minutes cldb.auto.offload.frequency.minutes cldb.auto.offload.max.volumes.allowed \
    cldb.auto.offload.threshold.gb cldb.balancer.disk.deltaToRepopulateStoragePoolsBins \
    cldb.balancer.disk.deltatorepopulatestoragepoolsbins cldb.balancer.disk.max.switches.in.nodes.percentage \
    cldb.balancer.disk.overused.threshold cldb.balancer.disk.sleep.interval.sec cldb.balancer.disk.threshold.percentage \
    cldb.balancer.role.max.switches.in.nodes.percentage cldb.balancer.role.paused \
    cldb.balancer.role.skip.container.active.sec cldb.balancer.role.sleep.interval.sec cldb.balancer.startup.interval.sec \
    cldb.cidgenerator.max.allowed.bitset.size cldb.cidgenerator.min.containerid cldb.cidgenerator.min.snap.containerid \
    cldb.cldb.metrics cldb.cluster.almost.full.percentage cldb.container.alloc.selector.algo \
    cldb.container.assign.buffer.sizemb cldb.container.assign.voucher.purge.interval.sec \
    cldb.container.block.updates.max.sec cldb.container.create.diskfull.threshold cldb.container.enospc.numskipacr \
    cldb.container.failure.threshold.heartbeats cldb.container.resyncnospacefail.wait.mins cldb.container.sizemb \
    cldb.containerassign.timeout.sec cldb.containers.create.count cldb.copied.tables.upgrade \
    cldb.datacontainer.block.updates.max.sec cldb.default.chunk.sizemb cldb.default.max.namespace.size.mb.alarm.thresh \
    cldb.default.node.topology cldb.default.volume.topology cldb.delete.unknown.container.copies.delay.hours \
    cldb.detect.cluster.restart cldb.detect.dup.hostid.enabled cldb.dialhome.metrics.file.rotation.period \
    cldb.dialhome.metrics.poll.interval cldb.dialhome.metrics.storage.interval cldb.disk.balancer.enable \
    cldb.ec.auto.offload.enabled cldb.enbale.ec.rebuild.feature cldb.enforce.old.volumes.dare cldb.feature.cid.reuse \
    cldb.feature.compression.lz4 cldb.feature.compression.zlib cldb.feature.mapr.user.enabled \
    cldb.feature.multi.compression cldb.feature.policiesmap.incache.enabled cldb.feature.separate.cldbvol.rpcs \
    cldb.feature.setgid cldb.feature.volumenumcntrs.incache.enabled cldb.feature.volumenumsnapshots.incache.enabled \
    cldb.fileserver.activityreport.interval.hb.multiplier cldb.fileserver.containerreport.interval.hb.multiplier \
    cldb.fileserver.heartbeat.interval.sec cldb.fileserver.metrics cldb.force.master.for.container.minutes \
    cldb.force.master.for.strongrepl.minutes cldb.fs.mark.inactive.sec cldb.fs.mark.rereplicate.sec \
    cldb.fs.reregistration.wait.time cldb.fs.summary.log.interval.sec cldb.fs.workallocator.num.volume.workunits \
    cldb.fs.workallocator.num.workunits cldb.fullcontainers.usage.percentage cldb.ganglia.cldb.metrics \
    cldb.ganglia.fileserver.metrics cldb.gateway.dead.resched.heartbeats cldb.gateway.heartbeat.seconds \
    cldb.gateway.retry.count cldb.gateway.retry.waittime.seconds cldb.gateway.threshold.heartbeats \
    cldb.hbstats.aggregation.refresh.interval cldb.heartbeat.increment.millis cldb.heartbeat.monitor.sleep.interval.sec \
    cldb.heartbeat.scale.threshold cldb.jmxremote.port cldb.jvm.monitor.acceptabledelay.millis cldb.key.delete.per.sec \
    cldb.limit.volume.spread cldb.local.volume.topology.trim.index cldb.log.fileserver.timeskew.interval.mins \
    cldb.logarchiver.enabled cldb.mapr.user.gid cldb.mapr.user.uid cldb.max.inodes.volume.alarm.thresh \
    cldb.max.parallel.resyncs.star cldb.mfs.heartbeat.timeout.multiple cldb.min.containerid cldb.min.fileservers \
    cldb.min.snap.containerid cldb.min.snapid cldb.minmax.refresh.interval.seconds cldb.nfs.refresh.cidcache.secs \
    cldb.nfs.refresh.volcache.secs cldb.nodes.topology.limit cldb.nodes.volumes.large.cluster cldb.numthreads \
    cldb.offload.gateway.assign.retrycount cldb.offload.gateway.assign.wait.seconds cldb.port cldb.purge.delay.hours \
    cldb.record.acr.processing.time cldb.reduce.container.size cldb.reject.root cldb.replica.chain.correction.enabled \
    cldb.replication.manager.critical.paused cldb.replication.manager.max.resyncs.in.nodes.percentage \
    cldb.replication.manager.over.paused cldb.replication.manager.start.mins \
    cldb.replication.max.in.transit.containers.per.sp cldb.replication.process.num.containers \
    cldb.replication.sleep.interval.sec cldb.replication.tablescan.interval.sec cldb.restart.wait.time.sec \
    cldb.rm.wait.fork.on.same.rack.mins cldb.rm.wait.rack.violated.fork.copy.mins cldb.role.balancer.logging.on \
    cldb.role.balancer.replicascount.tolerance cldb.role.balancer.replicassize.tolerance cldb.role.balancer.strategy \
    cldb.security.blacklist.cleanup.duration.seconds cldb.security.resolve.user cldb.security.user.ticket.duration.seconds \
    cldb.security.user.ticket.max.duration.seconds cldb.security.user.ticket.renew.duration.seconds \
    cldb.security.user.ticket.renew.max.duration.seconds cldb.snapshot.size.update.completion.delay \
    cldb.snapshot.size.update.delay.first cldb.snapshot.size.update.delay.second cldb.snapshot.size.update.delay.third \
    cldb.snapshots.inprogress.cleanup.minutes cldb.snapshotusageupdate.timeout.sec cldb.sortedlist.refresh.interval \
    cldb.sp.refill.utility.enable cldb.squash.root cldb.startup.waitfor.null.master.return.minutes \
    cldb.table.max.splits.in.nodes.percentage cldb.throttle.snapshot.keys.deletion cldb.tier.gw.balance.delay.dead.gw \
    cldb.tier.gw.balance.delay.new.gw cldb.tier.gw.balance.delay.recheck cldb.tier.gw.balance.delay.vol.create \
    cldb.tier.gw.balance.delay.vol.delete cldb.topology.almost.full.percentage cldb.unknowncontainers.recount.delay.min \
    cldb.upgrade.fix.aekey.comparator.aetype cldb.upgrade.fix.atime.oldervolumes cldb.upgrade.fix.delegated.admin.acls \
    cldb.upgrade.fix.empty.acls cldb.upgrade.fix.max.inodes.per.volume cldb.upgrade.fix.min.repl cldb.use.volid.in.mapcache \
    cldb.v2.features.enabled cldb.v3.features.enabled cldb.verbose.logging.enabled cldb.vip.failure.threshold.heartbeats \
    cldb.volume.balancing.enable cldb.volume.epoch cldb.volume.spread.formula cldb.volume.wire.security.default \
    cldb.volumeatimeupdate.interval.min cldb.volumemirror.numresyncpernode cldb.volumes.default.min.replication \
    cldb.volumes.default.replication cldb.volumes.namespace.default.min.replication \
    cldb.volumes.namespace.default.replication cldb.volumes.purge.frequency cldb.watermark.high.num.stalecontainers \
    cldb.watermark.high.stalereporting.servers cldb.web.https.port cldb.web.port cldb.zookeeper.servers \
    dbal.above.avg.bin.size dbal.avg.bin.size dbal.below.avg.bin.size dbal.below.avg.bins.balancing.frequency \
    dbal.below.avg.bins.balancing.threshold dbal.loadtracker.info.log.frequency dbal.overused.bin.size \
    dead.nfsnodes.removal.delay.mins dialhome_lookup_url dialhome_post_url ec.verbose.logging ecvolume.min.replicas \
    ecvolume.namespace.min.replicas ecvolume.namespace.num.replicas ecvolume.num.replicas enable.replicas.invariant.check \
    hadoop.version mapr.audit.cluster.mgmt.ops mapr.audit.cluster.retention.days mapr.audit.cluster.volume.size.mb \
    mapr.audit.data.access mapr.audit.data.retention.days mapr.audit.data.volume.size.mb \
    mapr.convert.take.snapshot.on.conversion mapr.dare.alarm.pending mapr.fs.nocompression mapr.fs.permissions.supergroup \
    mapr.fs.permissions.superuser mapr.mirror.concurrent.ops mapr.targetversion mapr.volume.dare.default \
    mcs.eula.6.1.0.acceptance mcs.metering.upload.data mfs.critical.resync.factor mfs.db.activityreport.interval.secs \
    mfs.db.copy.networkio.throttlefactor mfs.db.enable.copy.optimization mfs.db.max.rowsize.kb mfs.db.parallel.copyregions \
    mfs.db.parallel.copytables mfs.db.parallel.replicasetups mfs.disable.metrics.compression mfs.enable.audit.as.stream \
    mfs.enforce.dare mfs.feature.audit.support mfs.feature.bulkwrite mfs.feature.dare mfs.feature.db.ace.support \
    mfs.feature.db.bulkload.support mfs.feature.db.json.support mfs.feature.db.regionmerge.support \
    mfs.feature.db.repl.support mfs.feature.db.spillv2.support mfs.feature.db.streams.v6.support \
    mfs.feature.db.streams.v6dot1.support mfs.feature.devicefile.support mfs.feature.disk.flush \
    mfs.feature.enforce.min.replication mfs.feature.external.ip mfs.feature.fastacr.support mfs.feature.fastfailover \
    mfs.feature.fastinodescan.support mfs.feature.fileace.support mfs.feature.filecipherbit.support \
    mfs.feature.hardlinks.support mfs.feature.mast.support mfs.feature.metrics.support \
    mfs.feature.name.container.size.control mfs.feature.rwmirror.support mfs.feature.sealfile.support \
    mfs.feature.sercmd.support mfs.feature.snapshotdb.lite mfs.feature.snapshotdb.lite.enable \
    mfs.feature.storage.tiering.support mfs.feature.streams.connect.support mfs.feature.tables mfs.feature.volume.upgrade \
    mfs.high.memory.alarm.threshold mfs.resync.disk.throttle.factor mfs.resync.network.throttle.factor \
    mfs.use.container.modification.history multimfs.memory.perinstance multimfs.numinstances.pernode \
    multimfs.numsps.perinstance num.volmirror.threads pernode.numcntrs.alarm.thr"

# Handle the first set of options...
  case "${prev}" in
      acl)
      COMPREPLY=( $(compgen -W "show userperms set edit" -- ${cur}) ) 
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
          userperms)
          COMPREPLY=( $(compgen -W "${acl_opts[@]/"-group"}" -- ${cur}) )
          return 0
          ;;
          -type)
          COMPREPLY=( $(compgen -W "cluster volume" -- ${cur}) )
          return 0
          ;;
	  
      alarm)
      COMPREPLY=( $(compgen -W "list raise clear clearall config names" -- ${cur}) )
      return 0
	;;
      acerole)
      COMPREPLY=( $(compgen -W "validate" -- ${cur}) )
      return 0
	;;
        validate)
        COMPREPLY=( $(compgen -W "-role" -- ${cur}) )
        return 0
          ;;
      audit)
      COMPREPLY=( $(compgen -W "data cluster info" -- ${cur}) )
      return 0
	;;
          data)
          COMPREPLY=( $(compgen -W "-cluster -enabled -maxsize -retention" -- ${cur}) )
          return 0
          ;;
      blacklist)
      COMPREPLY=( $(compgen -W "user listusers" -- ${cur}) )
      return 0
	;;
	
      cluster)
      COMPREPLY=( $(compgen -W "gateway feature info queryservice" -- ${cur}) )
      return 0
	;;
        feature)
        COMPREPLY=( $(compgen -W "enable list" -- ${cur}) )
        return 0
          ;;
        gateway)
        COMPREPLY=( $(compgen -W "get set delete list resolve local" -- ${cur}) )
        return 0
          ;;
        queryservice)
        COMPREPLY=( $(compgen -W "getconfig setconfig clearconfig" -- ${cur}) )
        return 0
          ;;
        getconfig|clearconfig)
        COMPREPLY=( $(compgen -W "-cluster" -- ${cur}) )
        return 0
          ;;
        setconfig)
        COMPREPLY=( $(compgen -W "-cluster -enabled  -clusterid -storageplugin -znode" -- ${cur}) )
        return 0
          ;;
      config)
      COMPREPLY=( $(compgen -W "load save" -- ${cur}) )
      return 0
	;;
	load) # config load. 
	  if [ $prev2 == "config" ]; then
	    COMPREPLY=( $(compgen -W "-keys -cluster" -- ${cur}) )
	    return 0
	    fi
	    return 1
	;;
      -keys)
        COMPREPLY=( $(compgen -W "${config_load_keys}" -- ${cur}) )
        return 0
          ;;

	save) # config save 
	  if [ $prev2 == "config" ]; then
	    COMPREPLY=( $(compgen -W "-values -test -cluster" -- ${cur}) )
	    return 0
	    fi
	    return 1
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
	    __node_services
	  ;;
	-action|-cldb|-fileserver|-hbmaster|-hbregionserver|-jobtracker|-nfs|-tasktracker|-webserver) 
	  COMPREPLY=( $(compgen -W "${service_action}" -- ${cur}) )
	  return 0
	    ;;
       -nodes|-node)
	  __list_all_nodes
	  ;;

       -cluster)
	  __list_cluster
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
      COMPREPLY=( $(compgen -W "-name -cluster -zkconnect" -- ${cur}) ) 
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
      -columns)
      COMPREPLY=( $(compgen -W "bmi bmo br bs csvc ncp cpc dsa fda drk dsc dro dst dsu dwk dwo nfd \
	fhb gw h hd nhmm hmf hn id ip jhb lla mac nmd mct mt mu nm ndh nha \
	nmc nma nmw nrs nmc pma rpf rpi rpo rpc svc sca  sfsa shma shra sha \
	sja sna sta swa sp tsa tla rp tms tmu trs tru cpt cpu vma vip vipe " -- ${cur}) )
      return 0
	;;	
	
      list)   # service, node, disk ,schedule
	  if [ $prev2 == "disk" ]; then
	    COMPREPLY=( $(compgen -W "-host -system -output" -- ${cur}) )
	    return 0
	    fi
	  if [ $prev2 == "schedule" ]; then
	    COMPREPLY=( $(compgen -W "$json" -- ${cur}) )
	    return 0
	    fi	    
	  if [ $prev2 == "node" ]; then
	    COMPREPLY=( $(compgen -W  "-alarmednodes -cluster -columns -filter -limit \
	    -nfsnodes -output -start -zkconnect" -- ${cur}) )
	    return 0
	    fi
	  if [ $prev2 == "service" ]; then
	    COMPREPLY=( $(compgen -W  "-node -cluster -zkconnect -output" -- ${cur}) )
	    return 0
	    fi
	  return 1
	;;
	
      -name) # urls, services , 
	  if [ $prev2 == "urls" ]; then
	    COMPREPLY=( $(compgen -W "cldb tasktracker jobtracker nodemanager resourcemanager historyserver" -- ${cur}) )
	    return 0
	    fi
	  if [ $prev2 == "services" ]; then
	    COMPREPLY=( $(compgen -W "hs2 hue hivemeta httpfs nodemanager oozie resourcemanager historyserver" -- ${cur}) )
	    return 0
	    fi
	    return 1
	;;
	
	create) # table,volume schedule create 
	  if [ $prev2 == "table" ]; then
	    COMPREPLY=( $(compgen -W "-path -bulkloadperm -purgeperm -autosplitperm -regionsizeperm -modifyfamilyperm -encryptperm \
	    -deletefamilyperm -versionsperm -compressionperm -memoryperm -readperm -writeperm -appendperm " -- ${cur}) )
	    return 0
	    fi
	
	  if [ $prev2 == "volume" ]; then
	    COMPREPLY=( $(compgen -W "-name -type -advisoryquota -ae -aetype -cluster -createparent -group -localvolumehost -localvolumeport \
	    -maxinodesalarmthreshold -minreplication -mount -path -quota -readonly -replication -replicationtype \
	    -rereplicationtimeoutsec -rootdirperms -schedule -source  -topology -user" -- ${cur}) )
	    return 0
	    fi
	  if [ $prev2 == "schedule" ]; then
	    COMPREPLY=( $(compgen -W "-cluster -schedule" -- ${cur}) )
	    return 0
	    fi
	    return 1
	;;
		
    *)
     if [ $numArgs -gt 3 ] ; then
	if  [ $first == "node" -a $second == "services" ]; then 
	__node_services
	return 0
	fi
     return 1
     fi
    ;;
    esac

    # complete the following only if current args < 2
  if [ $numArgs -le 2 ] ; then
  COMPREPLY=($(compgen -W "${main_opts}" -- ${cur})) 
  return 0
  fi
  
  }

complete -o bashdefault -o default -F __maprcli maprcli

