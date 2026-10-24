// src: litebox_shim_linux/src/syscalls/epoll.rs:806 | let task = crate::syscalls::tests::init_platform_with_pipe_broker();
method PreSpawnOperations(requestedCompletion: bool) returns (completed: bool)
// synth: expose whether setup through descriptor conversion completes normally
  ensures completed == requestedCompletion
// synth: helper body
{
  // src: litebox_shim_linux/src/syscalls/epoll.rs:808 | let (rfd_u, wfd_u) = task
  // src: litebox_shim_linux/src/syscalls/epoll.rs:809 | .sys_pipe2(litebox::fs::OFlags::empty())
  // src: litebox_shim_linux/src/syscalls/epoll.rs:810 | .expect("pipe2 failed");
  // src: litebox_shim_linux/src/syscalls/epoll.rs:811 | let rfd = i32::try_from(rfd_u).unwrap();
  // src: litebox_shim_linux/src/syscalls/epoll.rs:812 | let wfd = i32::try_from(wfd_u).unwrap();
  completed := requestedCompletion;
// synth: close helper
}
// src: litebox_shim_linux/src/lib.rs:1311 | /// Spawns a thread that runs with a clone of this task and a new TID.
// src: litebox_shim_linux/src/lib.rs:1313 | /// # Panics
// src: litebox_shim_linux/src/lib.rs:1314 | /// Panics if the test process is already terminating.
// src: litebox_shim_linux/src/lib.rs:1315 | #[must_use]
// src: litebox_shim_linux/src/lib.rs:1316 | pub(crate) fn spawn_clone_for_test<R>(
// src: litebox_shim_linux/src/lib.rs:1317 | &self,
// src: litebox_shim_linux/src/lib.rs:1318 | f: impl 'static + Send + FnOnce(Task<Platform, FS>) -> R,
// src: litebox_shim_linux/src/lib.rs:1319 | ) -> std::thread::JoinHandle<R>
// src: litebox_shim_linux/src/lib.rs:1320 | where
// src: litebox_shim_linux/src/lib.rs:1321 | R: 'static + Send,
// src: litebox_shim_linux/src/lib.rs:1322 | {
method spawn_clone_for_test(spawnPanics: bool) returns (completed: bool)
// synth: the documented panic prevents creation of the handle
  ensures completed == !spawnPanics
// synth: helper body
{
  // src: litebox_shim_linux/src/lib.rs:1314 | /// Panics if the test process is already terminating.
  completed := !spawnPanics;
// synth: close helper
}
// src: litebox_shim_linux/src/syscalls/epoll.rs:819 | // prepare fd_set for read
method PostSpawnOperations(requestedCompletion: bool) returns (completed: bool)
// synth: expose whether operations between spawning and joining complete normally
  ensures completed == requestedCompletion
// synth: helper body
{
  // src: litebox_shim_linux/src/syscalls/epoll.rs:820 | let mut rfds = bitvec::bitvec![0; rfd_u.next_multiple_of(64) as usize];
  // src: litebox_shim_linux/src/syscalls/epoll.rs:821 | rfds.set(rfd_u as usize, true);
  // src: litebox_shim_linux/src/syscalls/epoll.rs:823 | let ret = task
  // src: litebox_shim_linux/src/syscalls/epoll.rs:824 | .do_pselect(
  // src: litebox_shim_linux/src/syscalls/epoll.rs:825 | rfd_u + 1,
  // src: litebox_shim_linux/src/syscalls/epoll.rs:826 | Some(&mut rfds),
  // src: litebox_shim_linux/src/syscalls/epoll.rs:827 | None,
  // src: litebox_shim_linux/src/syscalls/epoll.rs:828 | None,
  // src: litebox_shim_linux/src/syscalls/epoll.rs:829 | Some(core::time::Duration::from_mins(1)),
  // src: litebox_shim_linux/src/syscalls/epoll.rs:830 | )
  // src: litebox_shim_linux/src/syscalls/epoll.rs:831 | .expect("pselect failed");
  // src: litebox_shim_linux/src/syscalls/epoll.rs:833 | // Expect pselect to indicate readiness (HUP should cause revents)
  // src: litebox_shim_linux/src/syscalls/epoll.rs:834 | assert!(ret > 0, "pselect should report ready for EOF/HUP");
  // src: litebox_shim_linux/src/syscalls/epoll.rs:835 | assert!(rfds.iter_ones().all(|fd| fd == rfd_u as usize));
  // src: litebox_shim_linux/src/syscalls/epoll.rs:837 | // read should return 0 (EOF)
  // src: litebox_shim_linux/src/syscalls/epoll.rs:838 | let mut out = [0u8; 8];
  // src: litebox_shim_linux/src/syscalls/epoll.rs:839 | let n = task.sys_read(rfd, &mut out, None).expect("read failed");
  // src: litebox_shim_linux/src/syscalls/epoll.rs:840 | assert_eq!(n, 0, "read should return 0 on EOF");
  // src: litebox_shim_linux/src/syscalls/epoll.rs:842 | let _ = task.sys_close(rfd);
  completed := requestedCompletion;
// synth: close helper
}
// src: litebox_shim_linux/src/syscalls/epoll.rs:843 | closer.join().unwrap();
method JoinUnwrap(closerPanicked: bool) returns (completed: bool, waited: bool)
// synth: joining waits for completion
  ensures waited
// synth: unwrap completes normally exactly when the joined thread did not panic
  ensures completed == !closerPanicked
// synth: helper body
{
  // src: litebox_shim_linux/src/syscalls/epoll.rs:843 | closer.join().unwrap();
  waited := true;
  // src: litebox_shim_linux/src/syscalls/epoll.rs:843 | closer.join().unwrap();
  completed := !closerPanicked;
// synth: close helper
}
// src: litebox_shim_linux/src/syscalls/epoll.rs:804 | #[test]
// src: litebox_shim_linux/src/syscalls/epoll.rs:805 | fn test_pselect_read_hup() {
method WorkflowEntry(preSpawnCompletes: bool, spawnPanics: bool, postSpawnCompletes: bool, closerPanicked: bool) returns (spawned: bool, waitedForCloser: bool, returnedNormally: bool)
// synth: complete intended property
  ensures (returnedNormally ==> waitedForCloser) && (spawned && closerPanicked ==> !returnedNormally)
// synth: entry body
{
  // src: litebox_shim_linux/src/syscalls/epoll.rs:805 | fn test_pselect_read_hup() {
  spawned, waitedForCloser, returnedNormally := false, false, false;
  // src: litebox_shim_linux/src/syscalls/epoll.rs:806 | let task = crate::syscalls::tests::init_platform_with_pipe_broker();
  var preSpawnCompleted := PreSpawnOperations(preSpawnCompletes);
  // src: litebox_shim_linux/src/syscalls/epoll.rs:810 | .expect("pipe2 failed");
  if !preSpawnCompleted
  // synth: branch body
  {
    // src: litebox_shim_linux/src/syscalls/epoll.rs:810 | .expect("pipe2 failed");
    return;
  // synth: close branch
  }
  // src: litebox_shim_linux/src/syscalls/epoll.rs:814 | let closer = task.spawn_clone_for_test(move |task| {
  // src: litebox_shim_linux/src/syscalls/epoll.rs:815 | std::thread::sleep(core::time::Duration::from_millis(100));
  // src: litebox_shim_linux/src/syscalls/epoll.rs:816 | task.sys_close(wfd).expect("close writer failed");
  // src: litebox_shim_linux/src/syscalls/epoll.rs:817 | });
  var spawnCompleted := spawn_clone_for_test(spawnPanics);
  // src: litebox_shim_linux/src/syscalls/epoll.rs:814 | let closer = task.spawn_clone_for_test(move |task| {
  if !spawnCompleted
  // synth: branch body
  {
    // src: litebox_shim_linux/src/syscalls/epoll.rs:814 | let closer = task.spawn_clone_for_test(move |task| {
    return;
  // synth: close branch
  }
  // src: litebox_shim_linux/src/syscalls/epoll.rs:814 | let closer = task.spawn_clone_for_test(move |task| {
  spawned := true;
  // src: litebox_shim_linux/src/syscalls/epoll.rs:819 | // prepare fd_set for read
  var postSpawnCompleted := PostSpawnOperations(postSpawnCompletes);
  // src: litebox_shim_linux/src/syscalls/epoll.rs:842 | let _ = task.sys_close(rfd);
  if !postSpawnCompleted
  // synth: branch body
  {
    // src: litebox_shim_linux/src/syscalls/epoll.rs:842 | let _ = task.sys_close(rfd);
    return;
  // synth: close branch
  }
  // src: litebox_shim_linux/src/syscalls/epoll.rs:843 | closer.join().unwrap();
  var joinCompleted, didWait := JoinUnwrap(closerPanicked);
  // src: litebox_shim_linux/src/syscalls/epoll.rs:843 | closer.join().unwrap();
  waitedForCloser := didWait;
  // src: litebox_shim_linux/src/syscalls/epoll.rs:843 | closer.join().unwrap();
  if !joinCompleted
  // synth: branch body
  {
    // src: litebox_shim_linux/src/syscalls/epoll.rs:843 | closer.join().unwrap();
    return;
  // synth: close branch
  }
  // src: litebox_shim_linux/src/syscalls/epoll.rs:843 | closer.join().unwrap();
  // src: litebox_shim_linux/src/syscalls/epoll.rs:844 | }
  returnedNormally := true;
// synth: close entry
}

method NfvRefuteReachProbe(preSpawnCompletes: bool, spawnPanics: bool, postSpawnCompletes: bool, closerPanicked: bool) returns (spawned: bool, waitedForCloser: bool, returnedNormally: bool)
  ensures false
{
  
  spawned, waitedForCloser, returnedNormally := false, false, false;
  
  var preSpawnCompleted := PreSpawnOperations(preSpawnCompletes);
  
  if !preSpawnCompleted
  
  {
    
    return;
  
  }
  
  
  
  
  var spawnCompleted := spawn_clone_for_test(spawnPanics);
  
  if !spawnCompleted
  
  {
    
    return;
  
  }
  
  spawned := true;
  
  var postSpawnCompleted := PostSpawnOperations(postSpawnCompletes);
  
  if !postSpawnCompleted
  
  {
    
    return;
  
  }
  
  var joinCompleted, didWait := JoinUnwrap(closerPanicked);
  
  waitedForCloser := didWait;
  
  if !joinCompleted
  
  {
    
    return;
  
  }
  
  
  returnedNormally := true;

}
