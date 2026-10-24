// src: litebox_shim_linux/src/syscalls/epoll.rs:764 | #[test]
// src: litebox_shim_linux/src/syscalls/epoll.rs:765 | fn test_pselect() {
method WorkflowEntry(initSucceeds: bool, pipe2Succeeds: bool, fdConversionsSucceed: bool, spawnSucceeds: bool, fdSetSucceeds: bool, pselectSucceeds: bool, readSucceeds: bool, closeRfdOk: bool, closeWfdOk: bool, writerPanicked: bool) returns (normal: bool, writerSpawned: bool, writerRetained: bool, pipeOperationsCompleted: bool, closesCompleted: bool, joinAttempted: bool, joinSucceeded: bool)
// synth: Complete intended property stated as one postcondition.
  ensures (writerSpawned ==> writerRetained) && (closesCompleted ==> pipeOperationsCompleted && joinAttempted) && (joinAttempted ==> writerRetained && closesCompleted) && (normal ==> joinAttempted && joinSucceeded) && (writerSpawned && writerPanicked ==> !normal)
// synth: Method body.
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:765 | fn test_pselect() {
  normal := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:765 | fn test_pselect() {
  writerSpawned := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:765 | fn test_pselect() {
  writerRetained := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:765 | fn test_pselect() {
  pipeOperationsCompleted := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:765 | fn test_pselect() {
  closesCompleted := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:765 | fn test_pselect() {
  joinAttempted := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:765 | fn test_pselect() {
  joinSucceeded := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:766 | let task = crate::syscalls::tests::init_platform_with_pipe_broker();
  var stepOk := EnvironmentSucceeds(initSucceeds);
// src: litebox_shim_linux/src/syscalls/epoll.rs:766 | let task = crate::syscalls::tests::init_platform_with_pipe_broker();
  if !stepOk
// synth: Exceptional branch.
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:766 | let task = crate::syscalls::tests::init_platform_with_pipe_broker();
    return;
// synth: End exceptional branch.
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:768 | let (rfd_u, wfd_u) = task
// src: litebox_shim_linux/src/syscalls/epoll.rs:769 | .sys_pipe2(litebox::fs::OFlags::empty())
// src: litebox_shim_linux/src/syscalls/epoll.rs:770 | .expect("pipe2 failed");
  stepOk := EnvironmentSucceeds(pipe2Succeeds);
// src: litebox_shim_linux/src/syscalls/epoll.rs:770 | .expect("pipe2 failed");
  if !stepOk
// synth: Exceptional branch.
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:770 | .expect("pipe2 failed");
    return;
// synth: End exceptional branch.
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:771 | let rfd = i32::try_from(rfd_u).unwrap();
// src: litebox_shim_linux/src/syscalls/epoll.rs:772 | let wfd = i32::try_from(wfd_u).unwrap();
  stepOk := EnvironmentSucceeds(fdConversionsSucceed);
// src: litebox_shim_linux/src/syscalls/epoll.rs:772 | let wfd = i32::try_from(wfd_u).unwrap();
  if !stepOk
// synth: Exceptional branch.
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:772 | let wfd = i32::try_from(wfd_u).unwrap();
    return;
// synth: End exceptional branch.
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:774 | let writer = task.spawn_clone_for_test(move |task| {
  stepOk := EnvironmentSucceeds(spawnSucceeds);
// src: litebox_shim_linux/src/syscalls/epoll.rs:774 | let writer = task.spawn_clone_for_test(move |task| {
  if !stepOk
// synth: Exceptional branch.
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:774 | let writer = task.spawn_clone_for_test(move |task| {
    return;
// synth: End exceptional branch.
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:774 | let writer = task.spawn_clone_for_test(move |task| {
  writerSpawned := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:774 | let writer = task.spawn_clone_for_test(move |task| {
  writerRetained := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:775 | std::thread::sleep(core::time::Duration::from_millis(100));
// src: litebox_shim_linux/src/syscalls/epoll.rs:776 | // write a byte
// src: litebox_shim_linux/src/syscalls/epoll.rs:777 | let buf = [0x41u8];
// src: litebox_shim_linux/src/syscalls/epoll.rs:778 | let written = task.sys_write(wfd, &buf, None).expect("write failed");
// src: litebox_shim_linux/src/syscalls/epoll.rs:779 | assert_eq!(written, 1);
// src: litebox_shim_linux/src/syscalls/epoll.rs:780 | });
  var writerWillPanic := writerPanicked;
// src: litebox_shim_linux/src/syscalls/epoll.rs:782 | // prepare fd_set for read
// src: litebox_shim_linux/src/syscalls/epoll.rs:783 | let mut rfds = bitvec::bitvec![0; rfd_u.next_multiple_of(64) as usize];
// src: litebox_shim_linux/src/syscalls/epoll.rs:784 | rfds.set(rfd_u as usize, true);
  stepOk := EnvironmentSucceeds(fdSetSucceeds);
// src: litebox_shim_linux/src/syscalls/epoll.rs:784 | rfds.set(rfd_u as usize, true);
  if !stepOk
// synth: Exceptional branch.
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:784 | rfds.set(rfd_u as usize, true);
    return;
// synth: End exceptional branch.
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:786 | // Call pselect
// src: litebox_shim_linux/src/syscalls/epoll.rs:787 | let ret = task
// src: litebox_shim_linux/src/syscalls/epoll.rs:788 | .do_pselect(rfd_u + 1, Some(&mut rfds), None, None, None)
// src: litebox_shim_linux/src/syscalls/epoll.rs:789 | .expect("pselect failed");
// src: litebox_shim_linux/src/syscalls/epoll.rs:790 | assert!(ret > 0, "pselect should report ready");
// src: litebox_shim_linux/src/syscalls/epoll.rs:791 | assert!(rfds.iter_ones().all(|fd| fd == rfd_u as usize));
  stepOk := EnvironmentSucceeds(pselectSucceeds);
// src: litebox_shim_linux/src/syscalls/epoll.rs:791 | assert!(rfds.iter_ones().all(|fd| fd == rfd_u as usize));
  if !stepOk
// synth: Exceptional branch.
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:791 | assert!(rfds.iter_ones().all(|fd| fd == rfd_u as usize));
    return;
// synth: End exceptional branch.
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:793 | // read
// src: litebox_shim_linux/src/syscalls/epoll.rs:794 | let mut out = [0u8; 8];
// src: litebox_shim_linux/src/syscalls/epoll.rs:795 | let n = task.sys_read(rfd, &mut out, None).expect("read failed");
// src: litebox_shim_linux/src/syscalls/epoll.rs:796 | assert_eq!(n, 1);
// src: litebox_shim_linux/src/syscalls/epoll.rs:797 | assert_eq!(out[0], 0x41);
  stepOk := EnvironmentSucceeds(readSucceeds);
// src: litebox_shim_linux/src/syscalls/epoll.rs:797 | assert_eq!(out[0], 0x41);
  if !stepOk
// synth: Exceptional branch.
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:797 | assert_eq!(out[0], 0x41);
    return;
// synth: End exceptional branch.
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:797 | assert_eq!(out[0], 0x41);
  pipeOperationsCompleted := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:799 | let _ = task.sys_close(rfd);
  var ignoredCloseRfd := EnvironmentSucceeds(closeRfdOk);
// src: litebox_shim_linux/src/syscalls/epoll.rs:800 | let _ = task.sys_close(wfd);
  var ignoredCloseWfd := EnvironmentSucceeds(closeWfdOk);
// src: litebox_shim_linux/src/syscalls/epoll.rs:800 | let _ = task.sys_close(wfd);
  closesCompleted := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:801 | writer.join().unwrap();
  joinAttempted := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:801 | writer.join().unwrap();
  joinSucceeded := JoinWriter(writerWillPanic);
// src: litebox_shim_linux/src/syscalls/epoll.rs:801 | writer.join().unwrap();
  if !joinSucceeded
// synth: Exceptional branch.
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:801 | writer.join().unwrap();
    return;
// synth: End exceptional branch.
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:801 | writer.join().unwrap();
  normal := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:802 | }
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:766 | let task = crate::syscalls::tests::init_platform_with_pipe_broker();
method EnvironmentSucceeds(observed: bool) returns (succeeded: bool)
// synth: Explicit abstract result supplied by the entry input.
  ensures succeeded == observed
// synth: Helper body.
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:766 | let task = crate::syscalls::tests::init_platform_with_pipe_broker();
  succeeded := observed;
// synth: End helper body.
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:801 | writer.join().unwrap();
method JoinWriter(writerPanicked: bool) returns (succeeded: bool)
// synth: Joining succeeds exactly when the writer did not panic.
  ensures succeeded == !writerPanicked
// synth: Helper body.
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:801 | writer.join().unwrap();
  succeeded := !writerPanicked;
// synth: End helper body.
}

method NfvRefuteReachProbe(initSucceeds: bool, pipe2Succeeds: bool, fdConversionsSucceed: bool, spawnSucceeds: bool, fdSetSucceeds: bool, pselectSucceeds: bool, readSucceeds: bool, closeRfdOk: bool, closeWfdOk: bool, writerPanicked: bool) returns (normal: bool, writerSpawned: bool, writerRetained: bool, pipeOperationsCompleted: bool, closesCompleted: bool, joinAttempted: bool, joinSucceeded: bool)
  ensures false
{

  normal := false;

  writerSpawned := false;

  writerRetained := false;

  pipeOperationsCompleted := false;

  closesCompleted := false;

  joinAttempted := false;

  joinSucceeded := false;

  var stepOk := EnvironmentSucceeds(initSucceeds);

  if !stepOk

  {

    return;

  }



  stepOk := EnvironmentSucceeds(pipe2Succeeds);

  if !stepOk

  {

    return;

  }


  stepOk := EnvironmentSucceeds(fdConversionsSucceed);

  if !stepOk

  {

    return;

  }

  stepOk := EnvironmentSucceeds(spawnSucceeds);

  if !stepOk

  {

    return;

  }

  writerSpawned := true;

  writerRetained := true;






  var writerWillPanic := writerPanicked;



  stepOk := EnvironmentSucceeds(fdSetSucceeds);

  if !stepOk

  {

    return;

  }






  stepOk := EnvironmentSucceeds(pselectSucceeds);

  if !stepOk

  {

    return;

  }





  stepOk := EnvironmentSucceeds(readSucceeds);

  if !stepOk

  {

    return;

  }

  pipeOperationsCompleted := true;

  var ignoredCloseRfd := EnvironmentSucceeds(closeRfdOk);

  var ignoredCloseWfd := EnvironmentSucceeds(closeWfdOk);

  closesCompleted := true;

  joinAttempted := true;

  joinSucceeded := JoinWriter(writerWillPanic);

  if !joinSucceeded

  {

    return;

  }

  normal := true;

}
