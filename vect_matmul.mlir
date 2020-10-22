
!SIZE = type vector<64 x 64 x f32>
!C = type memref<64 x 64 x f32>
!V = type vector<4096 x f32>



func @main() {
  
  %c4 = constant 4.00000e+00 : f32
  %z = constant 0.00000e+00 : f32
  %i0 = constant 0 : index
  %i1 = constant 1 : index

  
  %A = vector.broadcast %c4 : f32 to !SIZE
  %B = vector.broadcast %c4 : f32 to !SIZE
  // %C = vector.broadcast %c0 : f32, !SIZE
  %C = alloc() : !C

  %p = dim %C, %i0 : !C
  %q = dim %C, %i1 : !C
  %r = dim %C, %i1 : !C

  %a = vector.shape_cast %A : !SIZE to !V
  %b = vector.shape_cast %B : !SIZE to !V
  // %c = vector.shape_cast %C : !SIZE to !V


  %tlin_start = call @rtclock() : () -> f64

  %d = vector.matrix_multiply %a, %b  { lhs_rows = 64: i32, lhs_columns = 64: i32 , rhs_columns = 64: i32 }
      : (!V, !V) -> !V
      
  %c = vector.shape_cast %d : !V to !SIZE

  vector.transfer_write %c, %C[%i0,%i0] : !SIZE, !C

  %tlin_end = call @rtclock() : () -> f64




  //Calculating sum of all elements of ouput matrix
  %sumo = alloc() : memref<1xf32>
  linalg.fill(%sumo,%z) : memref<1xf32>, f32

 
  affine.for %i = 0 to %p{
    affine.for %j = 0 to %r{
      %sum1 = affine.load %sumo[%i0] : memref<1xf32>
      %oe = affine.load %C[%i,%j] : !C
      %sum2 = addf %sum1, %oe : f32
      affine.store %sum2, %sumo[%i0] : memref<1xf32>
    }
  }

  // Printing Sum of Output
  %sumoc = memref_cast %sumo : memref<1xf32> to memref<*xf32>
  call @print_memref_f32(%sumoc) : (memref<*xf32>) -> ()


  // GFLOPS Calculation
  %tlin = subf %tlin_end, %tlin_start : f64
  %pi64 = index_cast %p : index to i64
  %qi64 = index_cast %q : index to i64
  %ri64 = index_cast %r : index to i64

  %f1 = muli %pi64, %qi64 : i64
  %f2 = muli %f1, %ri64 : i64
  %c2 = constant 2 : i64
  %f4 = muli %f2, %c2 :i64
  %num_flops_f = sitofp %f4 : i64 to f64
  %flops = divf %num_flops_f, %tlin : f64

  call @print_flops(%flops) : (f64) -> ()

  return
}
 func @print_memref_f32(memref<*xf32>)
 func @print_flops(f64)
 func @rtclock() -> f64



