FROM fliem/extract_fa:v4


RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -

RUN apt-get update && \
    apt-get install -y \
      nodejs \
      zip && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g bids-validator@1.4.0

# This pip is now from conda
RUN pip install flywheel-sdk==12.4.2 \
      flywheel-bids==0.9.1 \
      psutil==5.6.3 && \
    rm -rf /root/.cache/pip

# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
WORKDIR ${FLYWHEEL}

# Save docker environ
ENV PYTHONUNBUFFERED 1
RUN python -c 'import os, json; f = open("/tmp/gear_environ.json", "w"); json.dump(dict(os.environ), f)'

# Copy executable/manifest to Gear
COPY manifest.json ${FLYWHEEL}/manifest.json
COPY utils ${FLYWHEEL}/utils
COPY run.py ${FLYWHEEL}/run.py

# Configure entrypoint
RUN chmod a+x ${FLYWHEEL}/run.py
ENTRYPOINT ["/flywheel/v0/run.py"]
