cmd_cov="fuzz/coverage/copy_gcda.py"

start_time=$(date +%s)
end_time=$((start_time + 24*60*60))

while true; do
  current_time=$(date +%s)
    if [ $current_time -ge $end_time ]; then
        python3 $cmd_cov
        echo "24小时已经过去，停止脚本执行。"
        kill -9 $pid
        exit
    fi
    python3 $cmd_cov
    sleep 1800
done
