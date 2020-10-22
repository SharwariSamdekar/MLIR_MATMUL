
PATH_PREFIX=/data/sharwari
LLVM_ROOT=$PATH_PREFIX/MLIR/llvm-project
PROSPAR_MLIR=$PATH_PREFIX/prospar-mlir
LLVM_BUILD_PATH=$LLVM_ROOT/build
MLIR_OPT_EXEC=$LLVM_BUILD_PATH/bin/mlir-opt
MLIR_CPU_RUNNER_EXEC=$LLVM_BUILD_PATH/bin/mlir-cpu-runner
MLIR_RUNNER_LIB=$LLVM_BUILD_PATH/lib/libmlir_runner_utils.so
MLIR_SHARED_LIBS=$LLVM_BUILD_PATH/lib/libmlir_c_runner_utils.so


# Lets see each line in effect

#$MLIR_OPT_EXEC -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std -convert-std-to-llvm $1

#$MLIR_OPT_EXEC -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std -convert-std-to-llvm -print-ir-after-all $1

#$MLIR_OPT_EXEC -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std -convert-std-to-llvm -print-ir-after="lower-affine" $1

#$MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=64 tile-sizes=64 tile-sizes=64" -print-ir-after="lower-affine" -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 

# $MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=64 tile-sizes=64 tile-sizes=32" -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 

# $MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=64 tile-sizes=32 tile-sizes=32"  -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 

# $MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=32 tile-sizes=32 tile-sizes=32"  -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 

# $MLIR_OPT_EXEC -affine-loop-tile="tile-sizes=64 tile-sizes=64 tile-sizes=32" -affine-loop-unroll="unroll-up-to-factor" -convert-linalg-to-affine-loops -lower-affine -convert-scf-to-std  -convert-std-to-llvm  $1 
