// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
method JoinUnwrap(workerPanicked: bool) returns (completed: bool, propagated: bool)
// synth: Contract for Rust JoinHandle::join followed by unwrap.
  ensures completed == !workerPanicked && propagated == workerPanicked
// synth: Helper body.
{
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
  completed := !workerPanicked;
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
  propagated := workerPanicked;
// synth: End helper.
}
// src: litebox_shim_linux/src/syscalls/net.rs:3002 | #[test]
// src: litebox_shim_linux/src/syscalls/net.rs:3003 | fn recvmmsg_lock_wakes_contended_waiter() {
method WorkflowEntry(init_platform_ok: bool, try_lock_ok: bool, spawn_ok: bool, started_send_ok: bool, worker_lock_ok: bool, acquired_send_ok: bool, started_recv_ok: bool, early_recv_is_err: bool, acquired_recv_ok: bool) returns (reachedAcquiredReport: bool, joinCalled: bool, joinCompleted: bool, returnedNormally: bool, workerPanicked: bool, workerPanicPropagated: bool)
// synth: Complete intended property.
  ensures reachedAcquiredReport ==> (joinCalled && (returnedNormally ==> joinCompleted) && (workerPanicked ==> workerPanicPropagated))
// synth: Entry body.
{
// src: litebox_shim_linux/src/syscalls/net.rs:3025 | acquired_rx
  reachedAcquiredReport := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
  joinCalled := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
  joinCompleted := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3029 | }
  returnedNormally := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3010 | let worker = task.spawn_clone_for_test(move |task| {
  workerPanicked := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
  workerPanicPropagated := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3004 | let task = init_platform();
  var active: bool := init_platform_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3005 | let lock = alloc::sync::Arc::new(super::RecvmmsgLock::new());
  var lockAllocated: bool := active;
// src: litebox_shim_linux/src/syscalls/net.rs:3006 | let guard = lock.try_lock().unwrap();
  active := active && lockAllocated && try_lock_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3007 | let (started_tx, started_rx) = std::sync::mpsc::channel();
  var startedChannelCreated: bool := active;
// src: litebox_shim_linux/src/syscalls/net.rs:3008 | let (acquired_tx, acquired_rx) = std::sync::mpsc::channel();
  var acquiredChannelCreated: bool := active;
// src: litebox_shim_linux/src/syscalls/net.rs:3009 | let worker_lock = alloc::sync::Arc::clone(&lock);
  var workerLockCloned: bool := active;
// src: litebox_shim_linux/src/syscalls/net.rs:3010 | let worker = task.spawn_clone_for_test(move |task| {
  var spawned: bool := active && spawn_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3010 | let worker = task.spawn_clone_for_test(move |task| {
  active := active && spawn_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3011 | started_tx.send(()).unwrap();
  var startedSent: bool := spawned && startedChannelCreated && started_send_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3012 | let _guard = worker_lock.lock_interruptibly(&task.wait_cx()).unwrap();
  var workerLockAcquired: bool := startedSent && workerLockCloned && worker_lock_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3013 | acquired_tx.send(()).unwrap();
  var workerReported: bool := workerLockAcquired && acquiredChannelCreated && acquired_send_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3014 | });
  workerPanicked := spawned && (!started_send_ok || (startedSent && !worker_lock_ok) || (workerLockAcquired && !acquired_send_ok));
// src: litebox_shim_linux/src/syscalls/net.rs:3016 | started_rx
// src: litebox_shim_linux/src/syscalls/net.rs:3017 | .recv_timeout(core::time::Duration::from_secs(1))
// src: litebox_shim_linux/src/syscalls/net.rs:3018 | .unwrap();
  active := active && startedSent && started_recv_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3019 | assert!(
// src: litebox_shim_linux/src/syscalls/net.rs:3020 | acquired_rx
// src: litebox_shim_linux/src/syscalls/net.rs:3021 | .recv_timeout(core::time::Duration::from_millis(20))
// src: litebox_shim_linux/src/syscalls/net.rs:3022 | .is_err()
// src: litebox_shim_linux/src/syscalls/net.rs:3023 | );
  active := active && early_recv_is_err;
// src: litebox_shim_linux/src/syscalls/net.rs:3024 | drop(guard);
  var guardDropped: bool := active;
// src: litebox_shim_linux/src/syscalls/net.rs:3025 | acquired_rx
// src: litebox_shim_linux/src/syscalls/net.rs:3026 | .recv_timeout(core::time::Duration::from_secs(1))
// src: litebox_shim_linux/src/syscalls/net.rs:3027 | .unwrap();
  active := active && guardDropped && workerReported && acquired_recv_ok;
// src: litebox_shim_linux/src/syscalls/net.rs:3027 | .unwrap();
  reachedAcquiredReport := active;
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
  if active
// synth: Join branch.
  {
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
    joinCalled := true;
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
    joinCompleted, workerPanicPropagated := JoinUnwrap(workerPanicked);
// src: litebox_shim_linux/src/syscalls/net.rs:3028 | worker.join().unwrap();
    active := joinCompleted;
// synth: End join branch.
  }
// src: litebox_shim_linux/src/syscalls/net.rs:3029 | }
  returnedNormally := active;
// synth: End entry.
}