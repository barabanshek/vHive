#!/bin/sh

start=$(date +%s%N)

# fibonacci
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/fibonacci:latest -invoke_cmd='fibonacci' -snapshot='reap' -memsize=512
if [ "$1" = "fibonacci" ] && [ "$2" = "record" ]; then
echo "Invoking fibonacci for record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '200'
EOF
fi

if [ "$1" = "fibonacci" ] && [ "$2" = "replay" ]; then
echo "Invoking fibonacci for reply"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '400'
EOF
fi

# python linked-list traversing
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/python_list:latest -invoke_cmd='python_list' -snapshot='reap' -memsize=512
if [ "$1" = "python_list" ] && [ "$2" = "record" ]; then
echo "Invoking python_list"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '200'
EOF
fi

if [ "$1" = "python_list" ] && [ "$2" = "replay" ]; then
echo "Invoking python_list"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '400'
EOF
fi

# image_processing, low resolution
#   - WARNING: we call the same argument for record and replay because the rotation happens inside the function
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/image_processing:latest -invoke_cmd='image_processing_low' -snapshot='reap' -memsize=512
if [ "$1" = "image_processing_low" ] && [ "$2" = "record" ]; then
echo "Invoking image processing with low resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'low'
EOF
fi

if [ "$1" = "image_processing_low" ] && [ "$2" = "replay" ]; then
echo "Invoking image processing with low resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'low'
EOF
fi

# image_processing, hd resolution
#   - WARNING: we call the same argument for record and replay because the rotation happens inside the function
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/image_processing:latest -invoke_cmd='image_processing_hd' -snapshot='reap' -memsize=512
if [ "$1" = "image_processing_hd" ] && [ "$2" = "record" ]; then
echo "Invoking image processing with hd resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'hd'
EOF
fi

if [ "$1" = "image_processing_hd" ] && [ "$2" = "replay" ]; then
echo "Invoking image processing with hd resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'hd'
EOF
fi

# image_processing, default images from the original benchmark
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/image_processing:latest -invoke_cmd='image_processing_default' -snapshot='reap' -memsize=512
if [ "$1" = "image_processing_default" ] && [ "$2" = "record" ]; then
echo "Invoking image processing with hd resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'record'
EOF
fi

if [ "$1" = "image_processing_default" ] && [ "$2" = "replay" ]; then
echo "Invoking image processing with hd resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'replay'
EOF
fi

# matmul
#   - WARNING: we call the same argument for record and replay because matmul inside generates random data every invocation
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/matmul:latest -invoke_cmd='matmul' -snapshot='reap' -memsize=1024
if [ "$1" = "matmul" ] && [ "$2" = "record" ]; then
echo "Invoking matmul record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '100'
EOF
fi

if [ "$1" = "matmul" ] && [ "$2" = "replay" ]; then
echo "Invoking matmul replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '100'
EOF
fi

# chameleon
#   - WARNING: we call the same argument for record and replay because matmul inside generates random data every invocation
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/chameleon:latest -invoke_cmd='chameleon' -snapshot='reap' -memsize=512
if [ "$1" = "chameleon" ] && [ "$2" = "record" ]; then
echo "Invoking chameleon record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '100'
EOF
fi

if [ "$1" = "chameleon" ] && [ "$2" = "replay" ]; then
echo "Invoking chameleon replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '100'
EOF
fi

# video_processing
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/video_processing:latest -invoke_cmd='video_processing' -snapshot='reap' -memsize=512
if [ "$1" = "video_processing" ] && [ "$2" = "record" ]; then
echo "Invoking video_processing record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "record"
EOF
fi

if [ "$1" = "video_processing" ] && [ "$2" = "replay" ]; then
echo "Invoking video_processing replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "replay"
EOF
fi

# ml_serving
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/ml_lr_prediction:latest -invoke_cmd='ml_serving' -snapshot='reap' -memsize=512
if [ "$1" = "ml_serving" ] && [ "$2" = "record" ]; then
echo "Invoking ml_serving record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "any dummy request"
EOF
fi

if [ "$1" = "ml_serving" ] && [ "$2" = "replay" ]; then
echo "Invoking ml_serving replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "another dummy request, different length too"
EOF
fi

# cnn_image_classification
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/cnn_image_classification:latest -invoke_cmd='cnn_image_classification' -snapshot='reap' -memsize=1024
if [ "$1" = "cnn_image_classification" ] && [ "$2" = "record" ]; then
echo "Invoking cnn_image_classification record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "record"
EOF
fi

if [ "$1" = "cnn_image_classification" ] && [ "$2" = "replay" ]; then
echo "Invoking cnn_image_classification replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "replay"
EOF
fi

# rnn_serving
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/rnn_generate_character_level:latest -invoke_cmd='rnn_serving' -snapshot='reap' -memsize=1024
if [ "$1" = "rnn_serving" ] && [ "$2" = "record" ]; then
echo "Invoking rnn_serving record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "any text input"
EOF
fi

if [ "$1" = "rnn_serving" ] && [ "$2" = "replay" ]; then
echo "Invoking rnn_serving replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "another text input, different"
EOF
fi

# bfs
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/bfs:latest -invoke_cmd='bfs' -snapshot='reap' -memsize=512
if [ "$1" = "bfs" ] && [ "$2" = "record" ]; then
echo "Invoking bfs record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '60000'
EOF
fi

if [ "$1" = "bfs" ] && [ "$2" = "replay" ]; then
echo "Invoking bfs replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '30000'
EOF
fi

# dna_visualization_big
#   - WARNING: invoking same call here for record and replay as in the original benchmark; this makes sense though
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/dna_visualization:latest -invoke_cmd='dna_visualization_big' -snapshot='reap' -memsize=1024
if [ "$1" = "dna_visualization_big" ] && [ "$2" = "record" ]; then
echo "Invoking dna_visualization_big"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "big"
EOF
fi

if [ "$1" = "dna_visualization_big" ] && [ "$2" = "replay" ]; then
echo "Invoking dna_visualization_big"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "big"
EOF
fi

# dna_visualization_verybig
#   - WARNING: invoking same call here for record and replay as in the original benchmark; this makes sense though
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/dna_visualization:latest -invoke_cmd='dna_visualization_verybig' -snapshot='reap' -memsize=2048
if [ "$1" = "dna_visualization_verybig" ] && [ "$2" = "record" ]; then
echo "Invoking dna_visualization_verybig"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "verybig"
EOF
fi

if [ "$1" = "dna_visualization_verybig" ] && [ "$2" = "replay" ]; then
echo "Invoking dna_visualization_verybig"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "verybig"
EOF
fi

# dna_visualization_different_input
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/dna_visualization:latest -invoke_cmd='dna_visualization_different_input' -snapshot='reap' -memsize=2048
if [ "$1" = "dna_visualization_different_input" ] && [ "$2" = "record" ]; then
echo "Invoking dna_visualization_different_input"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "record"
EOF
fi

if [ "$1" = "dna_visualization_different_input" ] && [ "$2" = "replay" ]; then
echo "Invoking dna_visualization_different_input"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "replay"
EOF
fi

# resnet_img_recognition
if [ "$1" = "resnet_img_recognition" ]; then
echo "Invoking resnet_img_recognition"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
EOF
fi

# pagerank
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/pagerank:latest -invoke_cmd='pagerank' -snapshot='reap' -memsize=512
if [ "$1" = "pagerank" ] && [ "$2" = "record" ]; then
echo "Invoking pagerank record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "50000"
EOF
fi

if [ "$1" = "pagerank" ] && [ "$2" = "replay" ]; then
echo "Invoking pagerank replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "40000"
EOF
fi

# ml_video_face_detection_optimized
if [ "$1" = "ml_video_face_detection_optimized" ]; then
echo "Invoking ml_video_face_detection_optimized"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
EOF
fi

# model_training_10mb
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/model_training:latest -invoke_cmd='model_training_10mb' -snapshot='reap' -memsize=512
if [ "$1" = "model_training_10mb" ] && [ "$2" = "record" ]; then
echo "Invoking model_training record"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "reviews20mb.csv"
EOF
fi

if [ "$1" = "model_training_10mb" ] && [ "$2" = "replay" ]; then
echo "Invoking model_training replay"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "reviews10mb.csv"
EOF
fi

# model_training_20mb
#   - cmd: sudo -E env "PATH=$PATH" go run run_reap_end2end.go -image=127.0.0.1:5000/model_training:latest -invoke_cmd='model_training_20mb' -snapshot='reap' -memsize=512
if [ "$1" = "model_training_20mb" ] && [ "$2" = "record" ]; then
echo "Invoking model_training"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "reviews10mb.csv"
EOF
fi

if [ "$1" = "model_training_20mb" ] && [ "$2" = "replay" ]; then
echo "Invoking model_training"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "reviews20mb.csv"
EOF
fi

end=$(date +%s%N)

elapsed=$(( (end - start) / 1000 ))
echo "Time elapsed: $elapsed microseconds"
