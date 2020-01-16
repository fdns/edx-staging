FROM eoluchile/edx-platform:fd83da66e0d4721ef4416009d92419c7a133432d

# Install private requirements: this is useful for installing custom xblocks.
# In particular, to install xblocks from a private repository, clone the
# repositories to ./requirements on the host and add `-e ./myxblock/` to
# ./requirements/private.txt.
COPY ./requirements/ /openedx/requirements
RUN touch /openedx/requirements/private.txt \
    && pip install --src ../venv/src -r /openedx/requirements/private.txt

# Create folder that will store *.env.json and *.auth.json files
RUN mkdir -p /openedx/config ./lms/envs/prod ./cms/envs/prod
ENV CONFIG_ROOT /openedx/config
COPY settings/lms/*.py ./lms/envs/prod/
COPY settings/cms/*.py ./cms/envs/prod/

# Copy themes
COPY ./themes/ /openedx/themes/
RUN openedx-assets themes \
    && openedx-assets collect --settings=prod.assets
