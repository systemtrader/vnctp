# vnctp

ENV:

- ubuntu: 16.04
- python: 3.5.x
- boost: 1.66.0
- [vnpy](https://github.com/vnpy/vnpy)

CMD:

```sh
# Local
docker-compose build
docker-compose up
./sshDocker

# docker
./build.sh
python3 test/mdtest.py
python3 test/tdtest.py
```