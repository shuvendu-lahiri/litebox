// src: litebox_shim_linux/src/syscalls/net.rs:4166 | fn unix_socketpair_bidirectional(ty: SockType, is_nonblocking: bool) {
method WorkflowEntry(ty: int, is_nonblocking: bool, reaches_cleanup: bool, receiver2_panicked: bool, receiver1_panicked: bool) returns (receiver2_joined: bool, receiver1_joined: bool, normal_return: bool)
// synth: complete intended cleanup property
ensures ((reaches_cleanup && !receiver2_panicked) ==> (receiver2_joined && receiver1_joined)) && ((receiver2_joined && receiver2_panicked) ==> !normal_return) && ((receiver1_joined && receiver1_panicked) ==> !normal_return) && (normal_return ==> (reaches_cleanup && receiver2_joined && receiver1_joined))
// synth: method body
{
  // src: litebox_shim_linux/src/syscalls/net.rs:4166 | fn unix_socketpair_bidirectional(ty: SockType, is_nonblocking: bool) {
  receiver2_joined := false;
  // src: litebox_shim_linux/src/syscalls/net.rs:4166 | fn unix_socketpair_bidirectional(ty: SockType, is_nonblocking: bool) {
  receiver1_joined := false;
  // src: litebox_shim_linux/src/syscalls/net.rs:4166 | fn unix_socketpair_bidirectional(ty: SockType, is_nonblocking: bool) {
  normal_return := false;
  // src: litebox_shim_linux/src/syscalls/net.rs:4167 | let task = init_platform();
  var cleanupReached := ExecutionReachesCleanup(ty, is_nonblocking, reaches_cleanup);
  // src: litebox_shim_linux/src/syscalls/net.rs:4167 | let task = init_platform();
  if !cleanupReached
  // synth: conditional body
  {
    // src: litebox_shim_linux/src/syscalls/net.rs:4167 | let task = init_platform();
    return;
  // synth: conditional body
  }
  // src: litebox_shim_linux/src/syscalls/net.rs:4221 | receiver2.join().unwrap();
  receiver2_joined := true;
  // src: litebox_shim_linux/src/syscalls/net.rs:4221 | receiver2.join().unwrap();
  var receiver2_ok := JoinObserved(receiver2_panicked);
  // src: litebox_shim_linux/src/syscalls/net.rs:4221 | receiver2.join().unwrap();
  if !receiver2_ok
  // synth: conditional body
  {
    // src: litebox_shim_linux/src/syscalls/net.rs:4221 | receiver2.join().unwrap();
    return;
  // synth: conditional body
  }
  // src: litebox_shim_linux/src/syscalls/net.rs:4222 | receiver1.join().unwrap();
  receiver1_joined := true;
  // src: litebox_shim_linux/src/syscalls/net.rs:4222 | receiver1.join().unwrap();
  var receiver1_ok := JoinObserved(receiver1_panicked);
  // src: litebox_shim_linux/src/syscalls/net.rs:4222 | receiver1.join().unwrap();
  if !receiver1_ok
  // synth: conditional body
  {
    // src: litebox_shim_linux/src/syscalls/net.rs:4222 | receiver1.join().unwrap();
    return;
  // synth: conditional body
  }
  // src: litebox_shim_linux/src/syscalls/net.rs:4222 | receiver1.join().unwrap();
  normal_return := true;
// src: litebox_shim_linux/src/syscalls/net.rs:4223 | }
}

// src: litebox_shim_linux/src/syscalls/net.rs:4167 | let task = init_platform();
method ExecutionReachesCleanup(ty: int, is_nonblocking: bool, abstractReached: bool) returns (reached: bool)
// synth: explicit abstract result for omitted setup, communication, and cleanup-prefix behavior
ensures reached == abstractReached
// synth: helper body
{
  // src: litebox_shim_linux/src/syscalls/net.rs:4168 | let mut sv_ptr = alloc::vec![0u32; 2];
  // src: litebox_shim_linux/src/syscalls/net.rs:4169 | let sv_mut_ptr = UserPtrMut::from_usize(sv_ptr.as_mut_ptr() as usize);
  // src: litebox_shim_linux/src/syscalls/net.rs:4171 | let ty_and_flags = if is_nonblocking {
  // src: litebox_shim_linux/src/syscalls/net.rs:4172 | SockFlags::NONBLOCK.bits()
  // src: litebox_shim_linux/src/syscalls/net.rs:4173 | } else {
  // src: litebox_shim_linux/src/syscalls/net.rs:4174 | 0
  // src: litebox_shim_linux/src/syscalls/net.rs:4175 | } | ty as u32;
  // src: litebox_shim_linux/src/syscalls/net.rs:4176 | task.sys_socketpair(AddressFamily::UNIX as u32, ty_and_flags, 0, sv_mut_ptr)
  // src: litebox_shim_linux/src/syscalls/net.rs:4177 | .unwrap();
  // src: litebox_shim_linux/src/syscalls/net.rs:4179 | let sock1 = sv_ptr[0];
  // src: litebox_shim_linux/src/syscalls/net.rs:4180 | let sock2 = sv_ptr[1];
  // src: litebox_shim_linux/src/syscalls/net.rs:4182 | // Receive on sock2 (from sock1)
  // src: litebox_shim_linux/src/syscalls/net.rs:4183 | let receiver2 = task.spawn_clone_for_test(move |task| {
  // src: litebox_shim_linux/src/syscalls/net.rs:4184 | let mut buf = [0u8; 64];
  // src: litebox_shim_linux/src/syscalls/net.rs:4185 | if is_nonblocking {
  // src: litebox_shim_linux/src/syscalls/net.rs:4186 | ppoll(&task, sock2, Events::IN);
  // src: litebox_shim_linux/src/syscalls/net.rs:4187 | }
  // src: litebox_shim_linux/src/syscalls/net.rs:4188 | let n = task
  // src: litebox_shim_linux/src/syscalls/net.rs:4189 | .do_recvfrom(sock2, &mut buf, ReceiveFlags::empty(), None)
  // src: litebox_shim_linux/src/syscalls/net.rs:4190 | .expect("recvfrom failed");
  // src: litebox_shim_linux/src/syscalls/net.rs:4191 | assert_eq!(&buf[..n], b"Message from sock1");
  // src: litebox_shim_linux/src/syscalls/net.rs:4192 | });
  // src: litebox_shim_linux/src/syscalls/net.rs:4194 | std::thread::sleep(core::time::Duration::from_millis(100));
  // src: litebox_shim_linux/src/syscalls/net.rs:4195 | // Send from sock1 to sock2
  // src: litebox_shim_linux/src/syscalls/net.rs:4196 | let msg1 = "Message from sock1";
  // src: litebox_shim_linux/src/syscalls/net.rs:4197 | task.do_sendto(sock1, msg1.as_bytes(), SendFlags::empty(), None)
  // src: litebox_shim_linux/src/syscalls/net.rs:4198 | .expect("sendto failed");
  // src: litebox_shim_linux/src/syscalls/net.rs:4200 | let receiver1 = task.spawn_clone_for_test(move |task| {
  // src: litebox_shim_linux/src/syscalls/net.rs:4201 | // Receive on sock1 (from sock2)
  // src: litebox_shim_linux/src/syscalls/net.rs:4202 | let mut buf = [0u8; 64];
  // src: litebox_shim_linux/src/syscalls/net.rs:4203 | if is_nonblocking {
  // src: litebox_shim_linux/src/syscalls/net.rs:4204 | ppoll(&task, sock1, Events::IN);
  // src: litebox_shim_linux/src/syscalls/net.rs:4205 | }
  // src: litebox_shim_linux/src/syscalls/net.rs:4206 | let n = task
  // src: litebox_shim_linux/src/syscalls/net.rs:4207 | .do_recvfrom(sock1, &mut buf, ReceiveFlags::empty(), None)
  // src: litebox_shim_linux/src/syscalls/net.rs:4208 | .expect("recvfrom failed");
  // src: litebox_shim_linux/src/syscalls/net.rs:4209 | assert_eq!(&buf[..n], b"Message from sock2");
  // src: litebox_shim_linux/src/syscalls/net.rs:4210 | });
  // src: litebox_shim_linux/src/syscalls/net.rs:4212 | std::thread::sleep(core::time::Duration::from_millis(100));
  // src: litebox_shim_linux/src/syscalls/net.rs:4213 | // Send from sock2 to sock1
  // src: litebox_shim_linux/src/syscalls/net.rs:4214 | let msg2 = "Message from sock2";
  // src: litebox_shim_linux/src/syscalls/net.rs:4215 | task.do_sendto(sock2, msg2.as_bytes(), SendFlags::empty(), None)
  // src: litebox_shim_linux/src/syscalls/net.rs:4216 | .expect("sendto failed");
  // src: litebox_shim_linux/src/syscalls/net.rs:4218 | std::thread::sleep(core::time::Duration::from_millis(500));
  // src: litebox_shim_linux/src/syscalls/net.rs:4219 | close_socket(&task, sock1);
  // src: litebox_shim_linux/src/syscalls/net.rs:4220 | close_socket(&task, sock2);
  reached := abstractReached;
// synth: helper body
}

// src: litebox_shim_linux/src/syscalls/net.rs:4221 | receiver2.join().unwrap();
// src: litebox_shim_linux/src/syscalls/net.rs:4222 | receiver1.join().unwrap();
method JoinObserved(receiverPanicked: bool) returns (succeeded: bool)
// synth: Rust JoinHandle join is successful exactly when the receiver did not panic
ensures succeeded == !receiverPanicked
// synth: helper body
{
  // src: litebox_shim_linux/src/syscalls/net.rs:4221 | receiver2.join().unwrap();
  // src: litebox_shim_linux/src/syscalls/net.rs:4222 | receiver1.join().unwrap();
  succeeded := !receiverPanicked;
// synth: helper body
}