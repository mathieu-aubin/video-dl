#
# Regular cron jobs for the video-dl package
#
0 4	* * *	root	[ -x /usr/bin/video-dl_maintenance ] && /usr/bin/video-dl_maintenance
