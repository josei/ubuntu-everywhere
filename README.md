# 🌍 Ubuntu Everywhere 🌏

## 🤔 What it is

  * A super simple script: type `ubuntu` and run Ubuntu under Windows or Mac.

  * You'll get logged in as user `ubuntu` and have a persistent home folder and `sudo` privileges.

  * You'll find your Mac/Windows home folder at `~/host`.

  * You'll have Ruby (using RVM), Node.js (using NVM), Python, Erlang, Elixir, Go, C/C++, MongoDB, Redis, Nginx, Docker, SSH, TeXLive, ABC, Lilypond, Ethereum, Chromium, and Lynx already installed. 💪

## 😍 How to get it

  Easy peasy lemon squeezy:

  1. Install [Docker 🐳](https://docker.com/community-edition).

  2. Copy the script [ubuntu.bat](ubuntu.bat) (if using Windows) or [ubuntu](ubuntu) (if using Mac) into your `PATH`.

  3. Open a terminal, type `ubuntu` and voila! 💃

    ubuntu@4b8375b3aacf:~$


## 🤓 Tell me more

  * As you can imagine, Docker is used behind the scenes, so everything runs inside a Virtual Machine. Performance is good because Docker is so cool. Every time you run the `ubuntu` command, a Docker container is started, then automatically killed once logged out.

  * Basic networking:

      * Access a service running in Ubuntu: you need to expose the port first (e.g., expose Ubuntu's port 4567 as Mac/Windows's port 3000):

            ubuntu -p 3000:4567

            ubuntu@4b8375b3aacf:~$ gem install sinatra
            ubuntu@4b8375b3aacf:~$ ruby -e "require 'sinatra'; get('/') { 'hodor' }" -- -o 0.0.0.0
            [2017-07-09 20:39:07] INFO  WEBrick 1.3.1
            [2017-07-09 20:39:07] INFO  ruby 2.4.1 (2017-03-22) [x86_64-linux]
            == Sinatra (v2.0.0) has taken the stage on 4567 for development with backup from WEBrick
            [2017-07-09 20:39:07] INFO  WEBrick::HTTPServer#start: pid=319 port=4567

        You can now visit [http://localhost:3000](http://localhost:3000) in your favourite browser and you'll see your service running.

      * Access a service running in Ubuntu from Ubuntu. In this case, there's no need to expose ports, but you'd probably like to name your running container using the `--name` option to easily reference it from another container. You'll probably want to set a hostname for conveniency as well:

            ubuntu --name web --hostname web

            ubuntu@web:~$ gem install sinatra
            ubuntu@web:~$ ruby -e "require 'sinatra'; get('/') { 'hodor' }" -- -o 0.0.0.0
            [2017-07-09 20:39:07] INFO  WEBrick 1.3.1
            [2017-07-09 20:39:07] INFO  ruby 2.4.1 (2017-03-22) [x86_64-linux]
            == Sinatra (v2.0.0) has taken the stage on 4567 for development with backup from WEBrick
            [2017-07-09 20:39:07] INFO  WEBrick::HTTPServer#start: pid=319 port=4567

        Then, from another ubuntu container:

            ubuntu

            ubuntu@4b8375b3aacf:~$ curl -L web:4567
            hodor

  * Your home folder is persisted in a volume named `ubuntu`. MongoDB data is persisted using a volume named `mongodb`. Docker data is persisted using a volume named `docker`. Nginx configuration is persisted using a volume named `nginx`. Be careful if you prune your host's Docker data or you'll lose your home folder, MongoDB data, and the container's Docker data.

  * `/` is not persisted, so everything you install using `sudo` will be lost when logging out, as the container will be removed. This also means that every time you type `ubuntu`, a clean image is used.

  * Services are not running by default. To run MongoDB:

        sudo service mongodb start

    To run Redis:

        sudo service redis-server start

    To run Nginx:

        sudo service nginx start

    To run Docker:

        sudo service docker start

    To run SSH server:

        sudo service ssh start

  * How can you read your Ubuntu's home folder from Mac/Windows? Open SSH server is already installed, so you can mount an SSH filesystem folder on Windows/Mac and/or access your files using SFTP (you'll need to launch your container with `-p 22:22`, start the `ssh` service, and connect to `sftp://ubuntu@localhost`). Also, you can access your Mac/Windows home folder from Ubuntu's `~/host` folder. You could modify the `ubuntu` or `ubuntu.bat` script to mount your Windows/Mac home folder at `~` if you wish. However, home folders are separated for performance reasons (Mac/Windows filesystem is very slow when read/written from Ubuntu) and compatibility reasons (e.g., all Windows files have execution permissions, Mac's filesystem is not case-sensitive, and symbolic links can get naughty).

  * The hosts's filesystem is mounted as cached by default, so that the host's view is authoritative (permit delays before updates on the host appear in the container). This is done to improve performance. It can be changed by editing the `ubuntu` script that launches the container.

  * You can set default params to the `ubuntu` command through the `UBUNTU_PARAMS` environment variable.

  * Do you need additional packages installed in your Ubuntu? Fork the project, modify the [Dockerfile](Dockerfile) and create your own custom image.

## License

MIT license
