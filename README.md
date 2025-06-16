# hsr-humble-docker

From this repository: https://github.com/hsr-project/hsr_ros2_doc

起動方法
```
docker compose build
xhost local:
docker compose up
```

コンテナへ入る
```
docker exec -it hsrb_humble bash
source install/setup.bash
```

Python Interface (ihsrb)を使用する
```
ros2 run hsrb_interface_py ihsrb.py

```
2025/06/17 次のURLに記載しているコマンドは一通り実行可能なことを確認(https://github.com/hsr-project/hsr_ros2_doc/blob/humble/docs/hsrb_interface_jp.md#bringup-python-interface)


TODO
・cyclone ddsを設定


