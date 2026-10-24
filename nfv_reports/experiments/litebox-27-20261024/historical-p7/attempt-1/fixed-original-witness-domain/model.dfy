// src: litebox_shim_linux/src/syscalls/net.rs:4176 | task.sys_socketpair(AddressFamily::UNIX as u32, ty_and_flags, 0, sv_mut_ptr)
method EnvironmentStep(completes: bool) returns (completed: bool)
// synth: Contract exposes the undocumented success or panic outcome supplied by the entry.
  ensures completed == completes
// synth: Begin inferred environment helper.
{
// src: litebox_shim_linux/src/syscalls/net.rs:4177 | .unwrap();
  completed := completes;
// synth: End inferred environment helper.
}
// src: litebox_shim_linux/src/syscalls/net.rs:4183 | let receiver2 = task.spawn_clone_for_test(move |task| {
method SpawnReceiver(spawnCompletes: bool, isNonblocking: bool, bodyPanics: bool) returns (spawned: bool, polled: bool, panics: bool)
// synth: Contract models thread creation and the eventual abstract outcome of the captured closure.
  ensures spawned == spawnCompletes
// synth: A closure runs only after a successful spawn; its polling branch follows is_nonblocking.
  ensures spawned ==> polled == isNonblocking && panics == bodyPanics
// synth: No receiver exists when thread creation panics.
  ensures !spawned ==> !polled && !panics
// synth: Begin source-derived spawn abstraction.
{
// src: litebox_shim_linux/src/lib.rs:1323 | let task = self.clone_for_test().unwrap();
  spawned := spawnCompletes;
// src: litebox_shim_linux/src/lib.rs:1324 | std::thread::spawn(move || f(task))
  if spawned
// synth: Begin successful-spawn branch.
  {
// src: litebox_shim_linux/src/syscalls/net.rs:4185 | if is_nonblocking {
    if isNonblocking
// synth: Begin nonblocking polling branch.
    {
// src: litebox_shim_linux/src/syscalls/net.rs:4186 | ppoll(&task, sock2, Events::IN);
      polled := true;
// synth: End nonblocking polling branch.
    }
// src: litebox_shim_linux/src/syscalls/net.rs:4185 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:4187 | }
    else
// synth: Begin blocking branch.
    {
// src: litebox_shim_linux/src/syscalls/net.rs:4187 | }
      polled := false;
// synth: End blocking branch.
    }
// src: litebox_shim_linux/src/syscalls/net.rs:4190 | .expect("recvfrom failed");
    panics := bodyPanics;
// synth: End successful-spawn branch.
  }
// src: litebox_shim_linux/src/lib.rs:1323 | let task = self.clone_for_test().unwrap();
  else
// synth: Begin failed-spawn branch.
  {
// src: litebox_shim_linux/src/lib.rs:1313 | /// # Panics
// src: litebox_shim_linux/src/lib.rs:1314 | /// Panics if the test process is already terminating.
    polled := false;
// src: litebox_shim_linux/src/lib.rs:1316 | pub(crate) fn spawn_clone_for_test<R>(
    panics := false;
// synth: End failed-spawn branch.
  }
// synth: End source-derived spawn abstraction.
}
// src: litebox_shim_linux/src/syscalls/net.rs:4221 | receiver2.join().unwrap();
method JoinReceiver(receiverPanics: bool) returns (waited: bool, joinPanics: bool)
// synth: Joining waits for the receiver and unwrap panics exactly when the receiver panicked.
  ensures waited && joinPanics == receiverPanics
// synth: Begin source-derived join helper.
{
// src: litebox_shim_linux/src/syscalls/net.rs:4222 | receiver1.join().unwrap();
  waited := true;
// src: litebox_shim_linux/src/syscalls/net.rs:4221 | receiver2.join().unwrap();
  joinPanics := receiverPanics;
// synth: End source-derived join helper.
}
// src: litebox_shim_linux/src/syscalls/net.rs:4166 | fn unix_socketpair_bidirectional(ty: SockType, is_nonblocking: bool) {
method WorkflowEntry(ty: int, is_nonblocking: bool, prefixCompletes: bool, receiver2SpawnCompletes: bool, betweenSpawnsCompletes: bool, receiver1SpawnCompletes: bool, beforeJoinsCompletes: bool, receiver2Panics: bool, receiver1Panics: bool) returns (bothSpawned: bool, waitedReceiver2: bool, waitedReceiver1: bool, returnedNormally: bool, functionPanicked: bool, propagatedReceiverPanic: bool)
// synth: Preserve the complete selected property as one postcondition.
  ensures (bothSpawned && returnedNormally ==> waitedReceiver2 && waitedReceiver1) && (bothSpawned && (receiver2Panics || receiver1Panics) ==> functionPanicked && propagatedReceiverPanic)
// synth: Begin translation of the selected function.
// synth: refutation witness
  requires ty == 0
  requires is_nonblocking == false
  requires prefixCompletes == true
  requires receiver2SpawnCompletes == true
  requires betweenSpawnsCompletes == true
  requires receiver1SpawnCompletes == true
  requires beforeJoinsCompletes == false
  requires receiver2Panics == true
  requires receiver1Panics == false
{
// src: litebox_shim_linux/src/syscalls/net.rs:4167 | let task = init_platform();
  bothSpawned := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4168 | let mut sv_ptr = alloc::vec![0u32; 2];
  waitedReceiver2 := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4169 | let sv_mut_ptr = UserPtrMut::from_usize(sv_ptr.as_mut_ptr() as usize);
  waitedReceiver1 := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4171 | let ty_and_flags = if is_nonblocking {
  returnedNormally := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4172 | SockFlags::NONBLOCK.bits()
  functionPanicked := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4173 | } else {
// src: litebox_shim_linux/src/syscalls/net.rs:4174 | 0
// src: litebox_shim_linux/src/syscalls/net.rs:4175 | } | ty as u32;
  propagatedReceiverPanic := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4176 | task.sys_socketpair(AddressFamily::UNIX as u32, ty_and_flags, 0, sv_mut_ptr)
  var prefixOk := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4177 | .unwrap();
  prefixOk := EnvironmentStep(prefixCompletes);
// src: litebox_shim_linux/src/syscalls/net.rs:4177 | .unwrap();
  if !prefixOk
// synth: Begin prefix-panic path.
  {
// src: litebox_shim_linux/src/syscalls/net.rs:4179 | let sock1 = sv_ptr[0];
    functionPanicked := true;
// src: litebox_shim_linux/src/syscalls/net.rs:4177 | .unwrap();
    return;
// synth: End prefix-panic path.
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4180 | let sock2 = sv_ptr[1];
  var receiver2Spawned := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4182 | // Receive on sock2 (from sock1)
  var receiver2Polled := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4184 | let mut buf = [0u8; 64];
  var receiver2OutcomePanics := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4183 | let receiver2 = task.spawn_clone_for_test(move |task| {
// src: litebox_shim_linux/src/syscalls/net.rs:4185 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:4186 | ppoll(&task, sock2, Events::IN);
// src: litebox_shim_linux/src/syscalls/net.rs:4187 | }
// src: litebox_shim_linux/src/syscalls/net.rs:4188 | let n = task
// src: litebox_shim_linux/src/syscalls/net.rs:4189 | .do_recvfrom(sock2, &mut buf, ReceiveFlags::empty(), None)
// src: litebox_shim_linux/src/syscalls/net.rs:4190 | .expect("recvfrom failed");
// src: litebox_shim_linux/src/syscalls/net.rs:4191 | assert_eq!(&buf[..n], b"Message from sock1");
// src: litebox_shim_linux/src/syscalls/net.rs:4192 | });
  receiver2Spawned, receiver2Polled, receiver2OutcomePanics := SpawnReceiver(receiver2SpawnCompletes, is_nonblocking, receiver2Panics);
// src: litebox_shim_linux/src/syscalls/net.rs:4183 | let receiver2 = task.spawn_clone_for_test(move |task| {
  if !receiver2Spawned
// synth: Begin first-spawn panic path.
  {
// src: litebox_shim_linux/src/lib.rs:1314 | /// Panics if the test process is already terminating.
    functionPanicked := true;
// src: litebox_shim_linux/src/lib.rs:1323 | let task = self.clone_for_test().unwrap();
    return;
// synth: End first-spawn panic path.
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4194 | std::thread::sleep(core::time::Duration::from_millis(100));
  var betweenOk := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4195 | // Send from sock1 to sock2
// src: litebox_shim_linux/src/syscalls/net.rs:4196 | let msg1 = "Message from sock1";
// src: litebox_shim_linux/src/syscalls/net.rs:4197 | task.do_sendto(sock1, msg1.as_bytes(), SendFlags::empty(), None)
// src: litebox_shim_linux/src/syscalls/net.rs:4198 | .expect("sendto failed");
  betweenOk := EnvironmentStep(betweenSpawnsCompletes);
// src: litebox_shim_linux/src/syscalls/net.rs:4198 | .expect("sendto failed");
  if !betweenOk
// synth: Begin inter-spawn panic path.
  {
// src: litebox_shim_linux/src/syscalls/net.rs:4198 | .expect("sendto failed");
    functionPanicked := true;
// src: litebox_shim_linux/src/syscalls/net.rs:4198 | .expect("sendto failed");
    return;
// synth: End inter-spawn panic path.
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4200 | let receiver1 = task.spawn_clone_for_test(move |task| {
  var receiver1Spawned := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4201 | // Receive on sock1 (from sock2)
  var receiver1Polled := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4202 | let mut buf = [0u8; 64];
  var receiver1OutcomePanics := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4200 | let receiver1 = task.spawn_clone_for_test(move |task| {
// src: litebox_shim_linux/src/syscalls/net.rs:4203 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:4204 | ppoll(&task, sock1, Events::IN);
// src: litebox_shim_linux/src/syscalls/net.rs:4205 | }
// src: litebox_shim_linux/src/syscalls/net.rs:4206 | let n = task
// src: litebox_shim_linux/src/syscalls/net.rs:4207 | .do_recvfrom(sock1, &mut buf, ReceiveFlags::empty(), None)
// src: litebox_shim_linux/src/syscalls/net.rs:4208 | .expect("recvfrom failed");
// src: litebox_shim_linux/src/syscalls/net.rs:4209 | assert_eq!(&buf[..n], b"Message from sock2");
// src: litebox_shim_linux/src/syscalls/net.rs:4210 | });
  receiver1Spawned, receiver1Polled, receiver1OutcomePanics := SpawnReceiver(receiver1SpawnCompletes, is_nonblocking, receiver1Panics);
// src: litebox_shim_linux/src/syscalls/net.rs:4200 | let receiver1 = task.spawn_clone_for_test(move |task| {
  if !receiver1Spawned
// synth: Begin second-spawn panic path.
  {
// src: litebox_shim_linux/src/lib.rs:1323 | let task = self.clone_for_test().unwrap();
    functionPanicked := true;
// src: litebox_shim_linux/src/lib.rs:1323 | let task = self.clone_for_test().unwrap();
    return;
// synth: End second-spawn panic path.
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4200 | let receiver1 = task.spawn_clone_for_test(move |task| {
  bothSpawned := true;
// src: litebox_shim_linux/src/syscalls/net.rs:4212 | std::thread::sleep(core::time::Duration::from_millis(100));
  var beforeJoinsOk := false;
// src: litebox_shim_linux/src/syscalls/net.rs:4213 | // Send from sock2 to sock1
// src: litebox_shim_linux/src/syscalls/net.rs:4214 | let msg2 = "Message from sock2";
// src: litebox_shim_linux/src/syscalls/net.rs:4215 | task.do_sendto(sock2, msg2.as_bytes(), SendFlags::empty(), None)
// src: litebox_shim_linux/src/syscalls/net.rs:4216 | .expect("sendto failed");
// src: litebox_shim_linux/src/syscalls/net.rs:4218 | std::thread::sleep(core::time::Duration::from_millis(500));
// src: litebox_shim_linux/src/syscalls/net.rs:4219 | close_socket(&task, sock1);
// src: litebox_shim_linux/src/syscalls/net.rs:4220 | close_socket(&task, sock2);
  beforeJoinsOk := EnvironmentStep(beforeJoinsCompletes);
// src: litebox_shim_linux/src/syscalls/net.rs:4216 | .expect("sendto failed");
// src: litebox_shim_linux/src/syscalls/net.rs:4219 | close_socket(&task, sock1);
// src: litebox_shim_linux/src/syscalls/net.rs:4220 | close_socket(&task, sock2);

// experiment: proposed unwind-safe cleanup, not original-source provenance
  var receiver2JoinPanics := false;
  var receiver1JoinPanics := false;
  waitedReceiver2, receiver2JoinPanics := JoinReceiver(receiver2OutcomePanics);
  waitedReceiver1, receiver1JoinPanics := JoinReceiver(receiver1OutcomePanics);
  if receiver2JoinPanics || receiver1JoinPanics {
    functionPanicked := true;
    propagatedReceiverPanic := true;
    return;
  }
  if !beforeJoinsOk {
    functionPanicked := true;
    return;
  }
  returnedNormally := true;
}


method NfvRefuteReachProbe(ty: int, is_nonblocking: bool, prefixCompletes: bool, receiver2SpawnCompletes: bool, betweenSpawnsCompletes: bool, receiver1SpawnCompletes: bool, beforeJoinsCompletes: bool, receiver2Panics: bool, receiver1Panics: bool) returns (bothSpawned: bool, waitedReceiver2: bool, waitedReceiver1: bool, returnedNormally: bool, functionPanicked: bool, propagatedReceiverPanic: bool)



  requires ty == 0
  requires is_nonblocking == false
  requires prefixCompletes == true
  requires receiver2SpawnCompletes == true
  requires betweenSpawnsCompletes == true
  requires receiver1SpawnCompletes == true
  requires beforeJoinsCompletes == false
  requires receiver2Panics == true
  requires receiver1Panics == false
  ensures false
{

  bothSpawned := false;

  waitedReceiver2 := false;

  waitedReceiver1 := false;

  returnedNormally := false;

  functionPanicked := false;



  propagatedReceiverPanic := false;

  var prefixOk := false;

  prefixOk := EnvironmentStep(prefixCompletes);

  if !prefixOk

  {

    functionPanicked := true;

    return;

  }

  var receiver2Spawned := false;

  var receiver2Polled := false;

  var receiver2OutcomePanics := false;









  receiver2Spawned, receiver2Polled, receiver2OutcomePanics := SpawnReceiver(receiver2SpawnCompletes, is_nonblocking, receiver2Panics);

  if !receiver2Spawned

  {

    functionPanicked := true;

    return;

  }

  var betweenOk := false;




  betweenOk := EnvironmentStep(betweenSpawnsCompletes);

  if !betweenOk

  {

    functionPanicked := true;

    return;

  }

  var receiver1Spawned := false;

  var receiver1Polled := false;

  var receiver1OutcomePanics := false;









  receiver1Spawned, receiver1Polled, receiver1OutcomePanics := SpawnReceiver(receiver1SpawnCompletes, is_nonblocking, receiver1Panics);

  if !receiver1Spawned

  {

    functionPanicked := true;

    return;

  }

  bothSpawned := true;

  var beforeJoinsOk := false;







  beforeJoinsOk := EnvironmentStep(beforeJoinsCompletes);





  var receiver2JoinPanics := false;
  var receiver1JoinPanics := false;
  waitedReceiver2, receiver2JoinPanics := JoinReceiver(receiver2OutcomePanics);
  waitedReceiver1, receiver1JoinPanics := JoinReceiver(receiver1OutcomePanics);
  if receiver2JoinPanics || receiver1JoinPanics {
    functionPanicked := true;
    propagatedReceiverPanic := true;
    return;
  }
  if !beforeJoinsOk {
    functionPanicked := true;
    return;
  }
  returnedNormally := true;
}
