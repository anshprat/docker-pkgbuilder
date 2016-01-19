From ubuntu:latest

RUN apt-get -y update && apt-get install -y vim curl git python mysql-server python-setuptools python-dev libmysqlclient-dev libffi-dev libssl-dev

# python-six version conflict happens, so removing it
RUN apt-get remove -y python-six
RUN cd /home && git clone https://github.com/anshprat/python-overcast.django

# The first install fails with
# error: Could not find required distribution Django
# This works on subsequent runs, so making an explicit exit 0 here
# Any error if it persists would be caught in subsequent lines
RUN cd /home/python-overcast.django && git checkout setup_patch && python setup.py install || exit 0

# python-six removal removes pip as well, so installing it now that we need it
RUN apt-get install -y python-pip
RUN cd /home/python-overcast.django && grep drf-tracking requirements.txt|xargs -I id pip install id

## Now again remove python-six
RUN apt-get remove -y python-six

RUN cd /home/python-overcast.django && git checkout setup_patch && python setup.py install

