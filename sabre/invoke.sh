#!/bin/sh

start=$(date +%s%N)

# fibonacci
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/fibonacci:latest -invoke_cmd='fibonacci' -snapshot='Diff' -memsize=512
if [ "$1" = "fibonacci" ]; then
echo "Invoking fibonacci"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '200'
EOF
fi

# python linked-list traversing
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/python_list:latest -invoke_cmd='python_list' -snapshot='Diff' -memsize=512
if [ "$1" = "python_list" ]; then
echo "Invoking python_list"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '200'
EOF
fi

# image_processing, low resolution
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/image_processing:latest -invoke_cmd='image_processing_low' -snapshot='Diff' -memsize=256
if [ "$1" = "image_processing_low" ]; then
echo "Invoking image processing with low resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'low'
EOF
fi

# image_processing, hd resolution
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/image_processing:latest -invoke_cmd='image_processing_hd' -snapshot='Diff' -memsize=512
if [ "$1" = "image_processing_hd" ]; then
echo "Invoking image processing with hd resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'hd'
EOF
fi

# matmul
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/matmul:latest -invoke_cmd='matmul' -snapshot='Diff' -memsize=1024
if [ "$1" = "matmul" ]; then
echo "Invoking matmul"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '2000'
EOF
fi

# chameleon
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/chameleon:latest -invoke_cmd='chameleon' -snapshot='Diff' -memsize=512
if [ "$1" = "chameleon" ]; then
echo "Invoking chameleon"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '100'
EOF
fi

# video_processing
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/video_processing:latest -invoke_cmd='video_processing' -snapshot='Diff' -memsize=512
if [ "$1" = "video_processing" ]; then
echo "Invoking video_processing"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "lowres2"
EOF
fi

# ml_serving
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/ml_lr_prediction:latest -invoke_cmd='ml_serving' -snapshot='Diff' -memsize=512
if [ "$1" = "ml_serving" ]; then
echo "Invoking ml_serving"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "any dummy request"
EOF
fi

# cnn_image_classification
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/cnn_image_classification:latest -invoke_cmd='cnn_image_classification' -snapshot='Diff' -memsize=1024
if [ "$1" = "cnn_image_classification" ]; then
echo "Invoking cnn_image_classification"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "low"
EOF
fi

# rnn_serving
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/rnn_generate_character_level:latest -invoke_cmd='rnn_serving' -snapshot='Diff' -memsize=512
if [ "$1" = "rnn_serving" ]; then
echo "Invoking rnn_serving"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "any text input"
EOF
fi

# bfs
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/bfs:latest -invoke_cmd='bfs' -snapshot='Diff' -memsize=512
if [ "$1" = "bfs" ]; then
echo "Invoking bfs"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '50000'
EOF
fi

# dna_visualization_big
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/dna_visualization:latest -invoke_cmd='dna_visualization_big' -snapshot='Diff' -memsize=1024
if [ "$1" = "dna_visualization_big" ]; then
echo "Invoking dna_visualization_big"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "big"
EOF
fi

# dna_visualization_verybig
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/dna_visualization:latest -invoke_cmd='dna_visualization_verybig' -snapshot='Diff' -memsize=2048
if [ "$1" = "dna_visualization_verybig" ]; then
echo "Invoking dna_visualization_verybig"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "verybig"
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
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/pagerank:latest -invoke_cmd='pagerank' -snapshot='Diff' -memsize=512
if [ "$1" = "pagerank" ]; then
echo "Invoking pagerank"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "50000"
EOF
fi

# ml_video_face_detection_optimized
if [ "$1" = "ml_video_face_detection_optimized" ]; then
echo "Invoking ml_video_face_detection_optimized"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
EOF
fi

# model_training
#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/model_training:latest -invoke_cmd='model_training_10mb' -snapshot='Diff' -memsize=512
if [ "$1" = "model_training_10mb" ]; then
echo "Invoking model_training"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "reviews10mb.csv"
EOF
fi

#   - cmd: sudo -E env "PATH=$PATH" go run run_end2end.go -image=127.0.0.1:5000/model_training:latest -invoke_cmd='model_training_20mb' -snapshot='Diff' -memsize=512
if [ "$1" = "model_training_20mb" ]; then
echo "Invoking model_training"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "reviews20mb.csv"
EOF
fi

end=$(date +%s%N)

elapsed=$(( (end - start) / 1000 ))
echo "Time elapsed: $elapsed microseconds"
