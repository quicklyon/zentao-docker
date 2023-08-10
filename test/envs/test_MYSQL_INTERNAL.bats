#/usr/bin/envs bats

setup() {
  # 构建 Docker 镜像
  docker build -t myimage .
}

@test "MYSQL_INTERNAL=true should run internal MySQL" {
  run docker run --rm -e MYSQL_INTERNAL=true myimage some_command

  # 验证期望的输出或行为
  [ "$status" -eq 0 ]
  [ "$output" == "Expected output" ]
}

@test "MYSQL_INTERNAL=false should not run internal MySQL" {
  run docker run --rm -e MYSQL_INTERNAL=false myimage some_command

  # 验证期望的输出或行为
  [ "$status" -eq 0 ]
  [ "$output" == "Expected output" ]
}