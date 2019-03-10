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

## Reference

- [vnpy的ctp接口编译——ubuntu、python3环境](https://www.wepin.online/blog/0015423531636106a227723e4d74f21b6febcdef77a493f000)