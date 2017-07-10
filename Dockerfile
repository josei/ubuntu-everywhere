FROM ubuntu:16.04

ENV USER ubuntu

RUN apt update && apt install -y curl wget vim sudo tzdata man
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb && rm erlang-solutions_1.0_all.deb && apt update
RUN apt install -y mongodb redis-server nginx tmux git lynx openssh-server imagemagick esl-erlang elixir golang-go chromium-browser
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && DEBIAN_FRONTEND=noninteractive apt install -y linux-image-virtual apt-transport-https software-properties-common && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && apt update && apt install -y docker-ce
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && apt update && apt install -y mongodb-org
RUN apt install -y patch bzip2 gawk g++ gcc make libc6-dev patch zlib1g-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgmp-dev libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev libgmp-dev libreadline6-dev libssl-dev
RUN apt install -y texlive-full lilypond abcm2ps abcmidi
RUN add-apt-repository -y ppa:ethereum/ethereum && apt update && apt install -y ethereum solc

RUN useradd --create-home -s /bin/bash ${USER} && passwd -d ${USER} && adduser ${USER} sudo && adduser ${USER} docker && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /home/${USER}
USER ${USER}

RUN curl -sSL https://get.rvm.io | bash
RUN ln -s ~/.rvm/scripts/functions/version ~/.rvm/scripts/version
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

RUN bash -ilc "rvm install ruby && gem install bundler --no-ri --no-rdoc"
RUN bash -ilc "nvm install node && npm install -g coffee-script"

RUN git clone git://github.com/pyenv/pyenv.git ~/.pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
RUN echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.profile
ENV PATH ~/.pyenv/bin:$PATH
RUN bash -lc 'pyenv install 3.6.3'
RUN bash -lc 'pyenv global 3.6.3'
RUN bash -lc 'pip install pipenv'

RUN printf "export TERM=screen-256color\nexport LANG=C.UTF-8" >> ~/.profile
RUN touch ~/.sudo_as_admin_successful

ENTRYPOINT bash -il
