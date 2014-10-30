"""gunicorn WSGI server configuration."""
import os
import sys
import multiprocessing

def app_path():
    path = '{{project_path}}'
    if path not in sys.path:
       sys.path.append(path)

def pre_fork(server, worker):
    from django.db import connection
    connection.close()

# def when_ready(server):
#     """
#     Hook to activate Sentry
#     """
#     from django.core.management import call_command
#     call_command('validate')

def num_cpus():
    cpus = 0
    try:
        cpus = os.sysconf("SC_NPROCESSORS_ONLN")
    except:
        cpus = multiprocessing.cpu_count()
    if cpus:
        return cpus
    else:
        return 3

#defining the behavior of gunicorn
app_path()
bind = '{{gunicorn_bind_app}}'
workers = num_cpus()*2 + 1
debug = False
daemon = False
syslog = True
accesslog = '{{gunicorn_access_log}}'
errorlog = '{{gunicorn_error_log}}'
pidfile = '{{gunicorn_pid}}'
loglevel = 'info'
timeout = 120
