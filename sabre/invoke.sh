#!/bin/sh

start=$(date +%s%N)

# fibonacci
if [ "$1" = "fibonacci" ]; then
echo "Invoking fibonacci"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '200'
EOF
fi

# image_processing, low resolution
if [ "$1" = "image_processing_low" ]; then
echo "Invoking image processing with low resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'low'
EOF
fi

# image_processing, hd resolution
if [ "$1" = "image_processing_hd" ]; then
echo "Invoking image processing with hd resolution"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: 'hd'
EOF
fi

# matmul
if [ "$1" = "matmul" ]; then
echo "Invoking matmul"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '100'
EOF
fi

# chameleon
if [ "$1" = "chameleon" ]; then
echo "Invoking chameleon"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '100'
EOF
fi

# video-processing
if [ "$1" = "video_processing" ]; then
echo "Invoking video_processing"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
EOF
fi

# ml_lr_prediction
if [ "$1" = "ml_lr_prediction" ]; then
echo "Invoking ml_lr_prediction"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
EOF
fi

# cnn_image_classification
if [ "$1" = "cnn_image_classification" ]; then
echo "Invoking cnn_image_classification"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
EOF
fi

# rnn_generate_character_level
if [ "$1" = "rnn_generate_character_level" ]; then
echo "Invoking rnn_generate_character_level"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
EOF
fi

# bfs
if [ "$1" = "bfs" ]; then
echo "Invoking bfs"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: '50000'
EOF
fi

# dna_visualization
if [ "$1" = "dna_visualization" ]; then
echo "Invoking dna_visualization"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
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
if [ "$1" = "pagerank" ]; then
echo "Invoking pagerank"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
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
if [ "$1" = "model_training" ]; then
echo "Invoking model_training"
${GRPC_CLI}/grpc_cli call 172.16.0.2:50051 fibonacci.Greeter/SayHello <<EOF
name: "$2"
EOF
fi

end=$(date +%s%N)

elapsed=$(( (end - start) / 1000 ))
echo "Time elapsed: $elapsed microseconds"
