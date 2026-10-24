// src: litebox_shim_linux/src/syscalls/epoll.rs:655 | fn setup_epoll() -> (
method SetupEpollEnv(completesNormally: bool) returns (ok: bool)
// synth: contract exposing the omitted setup outcome
  ensures ok == completesNormally
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:659 | let task = crate::syscalls::tests::init_platform_with_pipe_broker();
// src: litebox_shim_linux/src/syscalls/epoll.rs:661 | let epoll = EpollFile::new();
// src: litebox_shim_linux/src/syscalls/epoll.rs:662 | (task, epoll)
// src: litebox_shim_linux/src/syscalls/epoll.rs:663 | }
  ok := completesNormally;
// synth: helper close
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:671 | .create_pipe(2, litebox::pipes::Flags::empty(), None)
method CreatePipeEnv(completesNormally: bool) returns (ok: bool)
// synth: contract exposing the omitted pipe-creation outcome
  ensures ok == completesNormally
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:672 | .unwrap();
  ok := completesNormally;
// synth: helper close
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:676 | .add_interest(
method AddInterestEnv(completesNormally: bool) returns (ok: bool)
// synth: contract exposing the omitted registration outcome
  ensures ok == completesNormally
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:681 | )
// src: litebox_shim_linux/src/syscalls/epoll.rs:682 | .unwrap();
  ok := completesNormally;
// synth: helper close
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:686 | let writer = std::thread::spawn(move || {
method SpawnWriterEnv(completesNormally: bool) returns (ok: bool)
// synth: contract exposing whether spawning returns a writer handle
  ensures ok == completesNormally
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:686 | let writer = std::thread::spawn(move || {
  ok := completesNormally;
// synth: helper close
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:686 | let writer = std::thread::spawn(move || {
method WriterClosureEnv(writeUnwraps: bool, writeReturnedTwo: bool) returns (finished: bool, panicked: bool)
// synth: eventual closure outcome derived from unwrap and assertion
  ensures finished
// synth: closure panic condition derived from the captured unwrap and equality assertion
  ensures panicked == (!writeUnwraps || !writeReturnedTwo)
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:687 | std::thread::sleep(core::time::Duration::from_millis(100));
  finished := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:688 | assert_eq!(
// src: litebox_shim_linux/src/syscalls/epoll.rs:689 | global
// src: litebox_shim_linux/src/syscalls/epoll.rs:690 | .pipes
// src: litebox_shim_linux/src/syscalls/epoll.rs:691 | .write(&WaitState::new(platform()).context(), &producer, &[1, 2])
// src: litebox_shim_linux/src/syscalls/epoll.rs:692 | .unwrap(),
// src: litebox_shim_linux/src/syscalls/epoll.rs:693 | 2
// src: litebox_shim_linux/src/syscalls/epoll.rs:694 | );
// src: litebox_shim_linux/src/syscalls/epoll.rs:695 | });
  panicked := !writeUnwraps || !writeReturnedTwo;
// synth: helper close
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:696 | epoll
method WaitEnv(completesNormally: bool) returns (ok: bool)
// synth: contract exposing the omitted wait outcome
  ensures ok == completesNormally
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:697 | .wait(&task.global, &WaitState::new(platform()).context(), 1024)
// src: litebox_shim_linux/src/syscalls/epoll.rs:698 | .unwrap();
  ok := completesNormally;
// synth: helper close
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:700 | task.global
method ReadEnv(completesNormally: bool, matchesExpected: bool) returns (ok: bool, buf: seq<int>)
// synth: contract exposing the omitted read outcome
  ensures ok == completesNormally
// synth: fixed-size source buffer
  ensures |buf| == 2
// synth: abstract post-read equality outcome
  ensures (buf == [1, 2]) == matchesExpected
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:702 | .read(&WaitState::new(platform()).context(), &consumer, &mut buf)
// src: litebox_shim_linux/src/syscalls/epoll.rs:703 | .unwrap();
  ok := completesNormally;
// src: litebox_shim_linux/src/syscalls/epoll.rs:702 | .read(&WaitState::new(platform()).context(), &consumer, &mut buf)
  if matchesExpected
// synth: matching-buffer branch
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:702 | .read(&WaitState::new(platform()).context(), &consumer, &mut buf)
    buf := [1, 2];
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:702 | .read(&WaitState::new(platform()).context(), &consumer, &mut buf)
  else
// synth: nonmatching-buffer branch
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:702 | .read(&WaitState::new(platform()).context(), &consumer, &mut buf)
    buf := [0, 0];
// synth: branch close
  }
// synth: helper close
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
method JoinWriterEnv(panicked: bool) returns (completed: bool, joinOk: bool)
// synth: joining waits for writer termination
  ensures completed
// synth: join succeeds exactly when the writer did not panic
  ensures joinOk == !panicked
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
  completed := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
  joinOk := !panicked;
// synth: helper close
}

// src: litebox_shim_linux/src/syscalls/epoll.rs:665 | #[test]
// src: litebox_shim_linux/src/syscalls/epoll.rs:666 | fn test_epoll_with_pipe() {
method WorkflowEntry(setupCompletes: bool, createPipeCompletes: bool, addInterestCompletes: bool, spawnCompletes: bool, writerWriteUnwraps: bool, writerWriteReturnedTwo: bool, waitCompletes: bool, readCompletes: bool, readBufMatches: bool) returns (finalSynchronizationReached: bool, writerJoined: bool, writerFinished: bool, writerPanicked: bool, panicPropagated: bool, returnsNormally: bool)
// synth: complete intended synchronization property
  ensures finalSynchronizationReached ==> (writerJoined && writerFinished && (returnsNormally ==> !writerPanicked) && (writerPanicked ==> panicPropagated && !returnsNormally))
// synth: entry body
{
// src: litebox_shim_linux/src/syscalls/epoll.rs:666 | fn test_epoll_with_pipe() {
  finalSynchronizationReached := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:666 | fn test_epoll_with_pipe() {
  writerJoined := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:666 | fn test_epoll_with_pipe() {
  writerFinished := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:666 | fn test_epoll_with_pipe() {
  writerPanicked := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:666 | fn test_epoll_with_pipe() {
  panicPropagated := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:666 | fn test_epoll_with_pipe() {
  returnsNormally := false;
// src: litebox_shim_linux/src/syscalls/epoll.rs:667 | let (task, epoll) = setup_epoll();
  var ok := SetupEpollEnv(setupCompletes);
// src: litebox_shim_linux/src/syscalls/epoll.rs:667 | let (task, epoll) = setup_epoll();
  if !ok
// synth: prior panic prevents reaching final synchronization
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:667 | let (task, epoll) = setup_epoll();
    return;
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:668 | let (producer, consumer) = task
// src: litebox_shim_linux/src/syscalls/epoll.rs:669 | .global
// src: litebox_shim_linux/src/syscalls/epoll.rs:670 | .pipes
// src: litebox_shim_linux/src/syscalls/epoll.rs:671 | .create_pipe(2, litebox::pipes::Flags::empty(), None)
// src: litebox_shim_linux/src/syscalls/epoll.rs:672 | .unwrap();
  ok := CreatePipeEnv(createPipeCompletes);
// src: litebox_shim_linux/src/syscalls/epoll.rs:672 | .unwrap();
  if !ok
// synth: unwrap failure exits exceptionally
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:672 | .unwrap();
    return;
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:673 | let consumer = Arc::new(consumer);
// src: litebox_shim_linux/src/syscalls/epoll.rs:674 | let reader = super::EpollDescriptor::Pipe(Arc::clone(&consumer));
  var readerPrepared := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:675 | epoll
// src: litebox_shim_linux/src/syscalls/epoll.rs:676 | .add_interest(
// src: litebox_shim_linux/src/syscalls/epoll.rs:677 | &task.global,
// src: litebox_shim_linux/src/syscalls/epoll.rs:678 | 10,
// src: litebox_shim_linux/src/syscalls/epoll.rs:679 | &reader,
// src: litebox_shim_linux/src/syscalls/epoll.rs:680 | EpollEvent::new(Events::IN.bits(), 0),
// src: litebox_shim_linux/src/syscalls/epoll.rs:681 | )
// src: litebox_shim_linux/src/syscalls/epoll.rs:682 | .unwrap();
  ok := AddInterestEnv(addInterestCompletes);
// src: litebox_shim_linux/src/syscalls/epoll.rs:682 | .unwrap();
  if !ok
// synth: unwrap failure exits exceptionally
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:682 | .unwrap();
    return;
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:684 | // spawn a thread to write to the pipe
// src: litebox_shim_linux/src/syscalls/epoll.rs:685 | let global = task.global.clone();
// src: litebox_shim_linux/src/syscalls/epoll.rs:686 | let writer = std::thread::spawn(move || {
  ok := SpawnWriterEnv(spawnCompletes);
// src: litebox_shim_linux/src/syscalls/epoll.rs:686 | let writer = std::thread::spawn(move || {
  if !ok
// synth: spawn failure prevents a usable join handle
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:686 | let writer = std::thread::spawn(move || {
    return;
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:686 | let writer = std::thread::spawn(move || {
// src: litebox_shim_linux/src/syscalls/epoll.rs:687 | std::thread::sleep(core::time::Duration::from_millis(100));
// src: litebox_shim_linux/src/syscalls/epoll.rs:688 | assert_eq!(
// src: litebox_shim_linux/src/syscalls/epoll.rs:689 | global
// src: litebox_shim_linux/src/syscalls/epoll.rs:690 | .pipes
// src: litebox_shim_linux/src/syscalls/epoll.rs:691 | .write(&WaitState::new(platform()).context(), &producer, &[1, 2])
// src: litebox_shim_linux/src/syscalls/epoll.rs:692 | .unwrap(),
// src: litebox_shim_linux/src/syscalls/epoll.rs:693 | 2
// src: litebox_shim_linux/src/syscalls/epoll.rs:694 | );
// src: litebox_shim_linux/src/syscalls/epoll.rs:695 | });
  var eventualFinished, eventualPanic := WriterClosureEnv(writerWriteUnwraps, writerWriteReturnedTwo);
// src: litebox_shim_linux/src/syscalls/epoll.rs:696 | epoll
// src: litebox_shim_linux/src/syscalls/epoll.rs:697 | .wait(&task.global, &WaitState::new(platform()).context(), 1024)
// src: litebox_shim_linux/src/syscalls/epoll.rs:698 | .unwrap();
  ok := WaitEnv(waitCompletes);
// src: litebox_shim_linux/src/syscalls/epoll.rs:698 | .unwrap();
  if !ok
// synth: wait unwrap failure exits exceptionally
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:698 | .unwrap();
    return;
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:699 | let mut buf = [0; 2];
  var buf: seq<int> := [0, 0];
// src: litebox_shim_linux/src/syscalls/epoll.rs:700 | task.global
// src: litebox_shim_linux/src/syscalls/epoll.rs:701 | .pipes
// src: litebox_shim_linux/src/syscalls/epoll.rs:702 | .read(&WaitState::new(platform()).context(), &consumer, &mut buf)
// src: litebox_shim_linux/src/syscalls/epoll.rs:703 | .unwrap();
  ok, buf := ReadEnv(readCompletes, readBufMatches);
// src: litebox_shim_linux/src/syscalls/epoll.rs:703 | .unwrap();
  if !ok
// synth: read unwrap failure exits exceptionally
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:703 | .unwrap();
    return;
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:704 | assert_eq!(buf, [1, 2]);
  if buf != [1, 2]
// synth: failed assertion exits exceptionally
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:704 | assert_eq!(buf, [1, 2]);
    return;
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
  finalSynchronizationReached := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
  var joinCompleted, joinOk := JoinWriterEnv(eventualPanic);
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
  writerJoined := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
  writerFinished := joinCompleted && eventualFinished;
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
  writerPanicked := eventualPanic;
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
  if !joinOk
// synth: unwrapping a failed join propagates the writer panic
  {
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
    panicPropagated := true;
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
    return;
// synth: branch close
  }
// src: litebox_shim_linux/src/syscalls/epoll.rs:705 | writer.join().unwrap();
// src: litebox_shim_linux/src/syscalls/epoll.rs:706 | }
  returnsNormally := true;
// synth: entry close
}