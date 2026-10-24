// src: litebox_shim_linux/src/syscalls/epoll.rs:708 | #[test]
// src: litebox_shim_linux/src/syscalls/epoll.rs:709 | fn test_poll() {
method PrefixModel(prefixCompletesNormally: bool) returns (normal: bool)
// synth: contract for the disclosed prefix abstraction
  ensures normal == prefixCompletesNormally
// synth: method body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:748 | assert!(revents(&set).is_empty());
  normal := prefixCompletesNormally;
// synth: close method body
}

// src: litebox_shim_linux/src/lib.rs:1316 | pub(crate) fn spawn_clone_for_test<R>(
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
method SpawnCloneForTestModel(spawnSucceeds: bool, writerThreadPanics: bool) returns (didSpawn: bool, threadPanics: bool)
// synth: modeled spawn outcome
  ensures didSpawn == spawnSucceeds
// synth: a thread outcome exists only after successful spawning
  ensures threadPanics == (spawnSucceeds && writerThreadPanics)
// synth: method body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
  didSpawn := spawnSucceeds;
// src: litebox_shim_linux/src/syscalls/epoll.rs:751 | std::thread::sleep(core::time::Duration::from_millis(100));
// src: litebox_shim_linux/src/syscalls/epoll.rs:752 | assert_eq!(task.sys_write(wfd, &[1], None).unwrap(), 1);
// src: litebox_shim_linux/src/syscalls/epoll.rs:753 | });
  threadPanics := spawnSucceeds && writerThreadPanics;
// synth: close method body
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:755 | set.wait(&task.global, &WaitState::new(platform()).context(), &fds)
method PollWaitModel(waitSucceeds: bool) returns (panics: bool)
// synth: unwrap panics exactly when the abstract wait result is an error
  ensures panics == !waitSucceeds
// synth: method body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:756 | .unwrap();
  panics := !waitSucceeds;
// synth: close method body
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:617 | /// Returns the accumulated `revents` for each entry in the poll set.
// src: litebox_shim_linux/src/syscalls/epoll.rs:620 | pub fn revents(&self) -> impl Iterator<Item = Events> + '_ {
method ReventsAssertionModel(reventsIsIn: bool) returns (panics: bool)
// synth: the assertion panics unless the observed event is IN
  ensures panics == !reventsIsIn
// synth: method body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:621 | self.entries.iter().map(|entry| entry.revents)
// src: litebox_shim_linux/src/syscalls/epoll.rs:622 | }
// src: litebox_shim_linux/src/syscalls/epoll.rs:757 | assert_eq!(revents(&set), Events::IN);
  panics := !reventsIsIn;
// synth: close method body
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:759 | let _ = task.sys_close(rfd);
method CloseModel(closePanics: bool) returns (panics: bool)
// synth: preserve whether the omitted close call panics
  ensures panics == closePanics
// synth: method body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:759 | let _ = task.sys_close(rfd);
  panics := closePanics;
// synth: close method body
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
method JoinModel(threadPanics: bool) returns (panics: bool)
// synth: join reports a panicked thread and unwrap propagates that error
  ensures panics == threadPanics
// synth: method body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
  panics := threadPanics;
// synth: close method body
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
method WorkflowEntry(prefixCompletesNormally: bool, spawnSucceeds: bool, writerThreadPanics: bool, waitSucceeds: bool, reventsIsIn: bool, closeRfdPanics: bool, closeWfdPanics: bool) returns (spawned: bool, joined: bool, returnedNormally: bool, testPanicked: bool)
// synth: complete intended property
  ensures (spawned ==> (returnedNormally ==> joined)) && (spawned && writerThreadPanics ==> testPanicked && !returnedNormally)
// synth: method body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
  var normal: bool;
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
  spawned := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
  joined := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:762 | }
  returnedNormally := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
  testPanicked := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
  normal := PrefixModel(prefixCompletesNormally);
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
  testPanicked := !normal;
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
  if normal
// synth: execution reached the writer-spawn suffix
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
    var didSpawn: bool;
// src: litebox_shim_linux/src/syscalls/epoll.rs:752 | assert_eq!(task.sys_write(wfd, &[1], None).unwrap(), 1);
    var threadPanics: bool;
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
// src: litebox_shim_linux/src/syscalls/epoll.rs:751 | std::thread::sleep(core::time::Duration::from_millis(100));
// src: litebox_shim_linux/src/syscalls/epoll.rs:752 | assert_eq!(task.sys_write(wfd, &[1], None).unwrap(), 1);
// src: litebox_shim_linux/src/syscalls/epoll.rs:753 | });
    didSpawn, threadPanics := SpawnCloneForTestModel(spawnSucceeds, writerThreadPanics);
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
    spawned := didSpawn;
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
    if !didSpawn
// synth: spawning panicked before producing a handle
    {
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
      normal := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:750 | let writer = task.spawn_clone_for_test(move |task| {
      testPanicked := true;
// synth: close spawn-failure branch
    }
// src: litebox_shim_linux/src/syscalls/epoll.rs:755 | set.wait(&task.global, &WaitState::new(platform()).context(), &fds)
    if normal
// synth: post-spawn wait path
    {
// src: litebox_shim_linux/src/syscalls/epoll.rs:756 | .unwrap();
      var waitPanics: bool;
// src: litebox_shim_linux/src/syscalls/epoll.rs:755 | set.wait(&task.global, &WaitState::new(platform()).context(), &fds)
// src: litebox_shim_linux/src/syscalls/epoll.rs:756 | .unwrap();
      waitPanics := PollWaitModel(waitSucceeds);
// src: litebox_shim_linux/src/syscalls/epoll.rs:756 | .unwrap();
      if waitPanics
// synth: wait unwrap failure path
      {
// src: litebox_shim_linux/src/syscalls/epoll.rs:756 | .unwrap();
        normal := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:756 | .unwrap();
        testPanicked := true;
// synth: close wait-failure branch
      }
// synth: close wait path
    }
// src: litebox_shim_linux/src/syscalls/epoll.rs:757 | assert_eq!(revents(&set), Events::IN);
    if normal
// synth: event assertion path
    {
// src: litebox_shim_linux/src/syscalls/epoll.rs:757 | assert_eq!(revents(&set), Events::IN);
      var assertionPanics: bool;
// src: litebox_shim_linux/src/syscalls/epoll.rs:757 | assert_eq!(revents(&set), Events::IN);
      assertionPanics := ReventsAssertionModel(reventsIsIn);
// src: litebox_shim_linux/src/syscalls/epoll.rs:757 | assert_eq!(revents(&set), Events::IN);
      if assertionPanics
// synth: failed event assertion path
      {
// src: litebox_shim_linux/src/syscalls/epoll.rs:757 | assert_eq!(revents(&set), Events::IN);
        normal := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:757 | assert_eq!(revents(&set), Events::IN);
        testPanicked := true;
// synth: close assertion-failure branch
      }
// synth: close assertion path
    }
// src: litebox_shim_linux/src/syscalls/epoll.rs:759 | let _ = task.sys_close(rfd);
    if normal
// synth: first close path
    {
// src: litebox_shim_linux/src/syscalls/epoll.rs:759 | let _ = task.sys_close(rfd);
      var closePanics: bool;
// src: litebox_shim_linux/src/syscalls/epoll.rs:759 | let _ = task.sys_close(rfd);
      closePanics := CloseModel(closeRfdPanics);
// src: litebox_shim_linux/src/syscalls/epoll.rs:759 | let _ = task.sys_close(rfd);
      if closePanics
// synth: first close panic path
      {
// src: litebox_shim_linux/src/syscalls/epoll.rs:759 | let _ = task.sys_close(rfd);
        normal := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:759 | let _ = task.sys_close(rfd);
        testPanicked := true;
// synth: close first-close failure branch
      }
// synth: close first-close path
    }
// src: litebox_shim_linux/src/syscalls/epoll.rs:760 | let _ = task.sys_close(wfd);
    if normal
// synth: second close path
    {
// src: litebox_shim_linux/src/syscalls/epoll.rs:760 | let _ = task.sys_close(wfd);
      var closePanics: bool;
// src: litebox_shim_linux/src/syscalls/epoll.rs:760 | let _ = task.sys_close(wfd);
      closePanics := CloseModel(closeWfdPanics);
// src: litebox_shim_linux/src/syscalls/epoll.rs:760 | let _ = task.sys_close(wfd);
      if closePanics
// synth: second close panic path
      {
// src: litebox_shim_linux/src/syscalls/epoll.rs:760 | let _ = task.sys_close(wfd);
        normal := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:760 | let _ = task.sys_close(wfd);
        testPanicked := true;
// synth: close second-close failure branch
      }
// synth: close second-close path
    }
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
    if normal
// synth: join path
    {
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
      joined := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
      var joinPanics: bool;
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
      joinPanics := JoinModel(threadPanics);
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
      if joinPanics
// synth: join unwrap failure path
      {
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
        normal := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:761 | writer.join().unwrap();
        testPanicked := true;
// synth: close join-failure branch
      }
// synth: close join path
    }
// synth: close reached-suffix branch
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:762 | }
  returnedNormally := normal;
// synth: close entry body
}