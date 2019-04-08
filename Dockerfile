FROM centos
 

ENTRYPOINT ["echo"]
CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]