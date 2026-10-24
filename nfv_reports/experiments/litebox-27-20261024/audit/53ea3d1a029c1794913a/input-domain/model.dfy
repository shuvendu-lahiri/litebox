// src: litebox_shim_linux/src/syscalls/net.rs:3981 | fn test_multiple_unix_stream_connections(is_nonblocking: bool) {
method WorkflowEntry(is_nonblocking: bool, setupCompletes: bool, spawnPanics: bool, serverWorkCompletes: bool, clientPanicsInput: bool) returns (serverWorkCompleted: bool, clientJoined: bool, joinAfterServerWork: bool, clientPanicked: bool, returnedSuccessfully: bool, testPanicked: bool)
// synth: complete intended property
  ensures (returnedSuccessfully ==> serverWorkCompleted && clientJoined && joinAfterServerWork) && (serverWorkCompleted && clientPanicked ==> clientJoined && joinAfterServerWork && testPanicked)
// synth: method body
{
// src: litebox_shim_linux/src/syscalls/net.rs:3981 | fn test_multiple_unix_stream_connections(is_nonblocking: bool) {
  serverWorkCompleted := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3981 | fn test_multiple_unix_stream_connections(is_nonblocking: bool) {
  clientJoined := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3981 | fn test_multiple_unix_stream_connections(is_nonblocking: bool) {
  joinAfterServerWork := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3981 | fn test_multiple_unix_stream_connections(is_nonblocking: bool) {
  clientPanicked := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3981 | fn test_multiple_unix_stream_connections(is_nonblocking: bool) {
  returnedSuccessfully := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3981 | fn test_multiple_unix_stream_connections(is_nonblocking: bool) {
  testPanicked := false;
// src: litebox_shim_linux/src/syscalls/net.rs:3982 | let task = init_platform();
// src: litebox_shim_linux/src/syscalls/net.rs:3983 | let addr = "/unix_multi_stream_socket.sock";
// src: litebox_shim_linux/src/syscalls/net.rs:3984 | let server_fd = create_unix_server_socket(
// src: litebox_shim_linux/src/syscalls/net.rs:3985 | &task,
// src: litebox_shim_linux/src/syscalls/net.rs:3986 | addr,
// src: litebox_shim_linux/src/syscalls/net.rs:3987 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:3988 | SockFlags::NONBLOCK
// src: litebox_shim_linux/src/syscalls/net.rs:3989 | } else {
// src: litebox_shim_linux/src/syscalls/net.rs:3990 | SockFlags::empty()
// src: litebox_shim_linux/src/syscalls/net.rs:3991 | },
// src: litebox_shim_linux/src/syscalls/net.rs:3992 | )
// src: litebox_shim_linux/src/syscalls/net.rs:3993 | .unwrap();
  var setupOk := SetupEnvironment(setupCompletes);
// src: litebox_shim_linux/src/syscalls/net.rs:3993 | .unwrap();
  if !setupOk
// synth: setup failure branch
  {
// src: litebox_shim_linux/src/syscalls/net.rs:3993 | .unwrap();
    testPanicked := true;
// src: litebox_shim_linux/src/syscalls/net.rs:3993 | .unwrap();
    return;
// synth: close setup failure branch
  }
// src: litebox_shim_linux/src/syscalls/net.rs:3995 | let client = task.spawn_clone_for_test(move |task| {
// src: litebox_shim_linux/src/syscalls/net.rs:3996 | let mut client_fds = Vec::new();
// src: litebox_shim_linux/src/syscalls/net.rs:3997 | for _ in 0..10 {
// src: litebox_shim_linux/src/syscalls/net.rs:3998 | let client_fd = create_unix_socket(
// src: litebox_shim_linux/src/syscalls/net.rs:3999 | &task,
// src: litebox_shim_linux/src/syscalls/net.rs:4000 | SockType::Stream,
// src: litebox_shim_linux/src/syscalls/net.rs:4001 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:4002 | SockFlags::NONBLOCK
// src: litebox_shim_linux/src/syscalls/net.rs:4003 | } else {
// src: litebox_shim_linux/src/syscalls/net.rs:4004 | SockFlags::empty()
// src: litebox_shim_linux/src/syscalls/net.rs:4005 | },
// src: litebox_shim_linux/src/syscalls/net.rs:4006 | );
// src: litebox_shim_linux/src/syscalls/net.rs:4007 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:4008 | ppoll(&task, server_fd, Events::OUT);
// src: litebox_shim_linux/src/syscalls/net.rs:4009 | }
// src: litebox_shim_linux/src/syscalls/net.rs:4010 | task.do_connect(
// src: litebox_shim_linux/src/syscalls/net.rs:4011 | client_fd,
// src: litebox_shim_linux/src/syscalls/net.rs:4012 | SocketAddress::Unix(UnixSocketAddr::Path(addr.to_string())),
// src: litebox_shim_linux/src/syscalls/net.rs:4013 | )
// src: litebox_shim_linux/src/syscalls/net.rs:4014 | .unwrap();
// src: litebox_shim_linux/src/syscalls/net.rs:4015 | client_fds.push(client_fd);
// src: litebox_shim_linux/src/syscalls/net.rs:4016 | }
// src: litebox_shim_linux/src/syscalls/net.rs:4018 | for (i, client_fd) in client_fds.iter().enumerate() {
// src: litebox_shim_linux/src/syscalls/net.rs:4019 | let msg = alloc::format!("message from connection {i}");
// src: litebox_shim_linux/src/syscalls/net.rs:4020 | let n = task
// src: litebox_shim_linux/src/syscalls/net.rs:4021 | .do_sendto(*client_fd, msg.as_bytes(), SendFlags::empty(), None)
// src: litebox_shim_linux/src/syscalls/net.rs:4022 | .expect("sendto failed");
// src: litebox_shim_linux/src/syscalls/net.rs:4023 | assert_eq!(n, msg.len());
// src: litebox_shim_linux/src/syscalls/net.rs:4024 | }
// src: litebox_shim_linux/src/syscalls/net.rs:4026 | for client_fd in client_fds {
// src: litebox_shim_linux/src/syscalls/net.rs:4027 | close_socket(&task, client_fd);
// src: litebox_shim_linux/src/syscalls/net.rs:4028 | }
// src: litebox_shim_linux/src/syscalls/net.rs:4029 | });
  var handleCreated: bool;
// src: litebox_shim_linux/src/syscalls/net.rs:3995 | let client = task.spawn_clone_for_test(move |task| {
  handleCreated, clientPanicked := SpawnClient(spawnPanics, clientPanicsInput);
// src: litebox_shim_linux/src/syscalls/net.rs:3995 | let client = task.spawn_clone_for_test(move |task| {
  if !handleCreated
// synth: spawn failure branch
  {
// src: litebox_shim_linux/src/syscalls/net.rs:3995 | let client = task.spawn_clone_for_test(move |task| {
    testPanicked := true;
// src: litebox_shim_linux/src/syscalls/net.rs:3995 | let client = task.spawn_clone_for_test(move |task| {
    return;
// synth: close spawn failure branch
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4031 | let mut server_conn_fds = Vec::new();
  var serverOk := ServerPhaseOutcome(serverWorkCompletes);
// src: litebox_shim_linux/src/syscalls/net.rs:4031 | let mut server_conn_fds = Vec::new();
  if !serverOk
// synth: server failure branch
  {
// src: litebox_shim_linux/src/syscalls/net.rs:4031 | let mut server_conn_fds = Vec::new();
    testPanicked := true;
// src: litebox_shim_linux/src/syscalls/net.rs:4031 | let mut server_conn_fds = Vec::new();
    return;
// synth: close server failure branch
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4032 | for _ in 0..10 {
  var accepted := 0;
// src: litebox_shim_linux/src/syscalls/net.rs:4032 | for _ in 0..10 {
  while accepted < 10
// synth: accepted connection count stays within the loop range
    invariant 0 <= accepted <= 10
// synth: loop termination metric
    decreases 10 - accepted
// synth: accept loop body
  {
// src: litebox_shim_linux/src/syscalls/net.rs:4033 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:4034 | ppoll(&task, server_fd, Events::IN);
// src: litebox_shim_linux/src/syscalls/net.rs:4035 | }
// src: litebox_shim_linux/src/syscalls/net.rs:4036 | let server_conn = task
// src: litebox_shim_linux/src/syscalls/net.rs:4037 | .do_accept(
// src: litebox_shim_linux/src/syscalls/net.rs:4038 | server_fd,
// src: litebox_shim_linux/src/syscalls/net.rs:4039 | None,
// src: litebox_shim_linux/src/syscalls/net.rs:4040 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:4041 | SockFlags::NONBLOCK
// src: litebox_shim_linux/src/syscalls/net.rs:4042 | } else {
// src: litebox_shim_linux/src/syscalls/net.rs:4043 | SockFlags::empty()
// src: litebox_shim_linux/src/syscalls/net.rs:4044 | },
// src: litebox_shim_linux/src/syscalls/net.rs:4045 | )
// src: litebox_shim_linux/src/syscalls/net.rs:4046 | .unwrap();
// src: litebox_shim_linux/src/syscalls/net.rs:4047 | server_conn_fds.push(server_conn);
// src: litebox_shim_linux/src/syscalls/net.rs:4048 | }
    accepted := accepted + 1;
// synth: close accept loop body
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4050 | for (i, server_conn_fd) in server_conn_fds.iter().enumerate() {
  var received := 0;
// src: litebox_shim_linux/src/syscalls/net.rs:4050 | for (i, server_conn_fd) in server_conn_fds.iter().enumerate() {
  while received < 10
// synth: received messages form a prefix of the accepted connections
    invariant 0 <= received <= 10
// synth: all ten connections have been accepted before receiving
    invariant accepted == 10
// synth: loop termination metric
    decreases 10 - received
// synth: receive loop body
  {
// src: litebox_shim_linux/src/syscalls/net.rs:4051 | let msg = alloc::format!("message from connection {i}");
// src: litebox_shim_linux/src/syscalls/net.rs:4052 | let mut buf = [0u8; 64];
// src: litebox_shim_linux/src/syscalls/net.rs:4053 | if is_nonblocking {
// src: litebox_shim_linux/src/syscalls/net.rs:4054 | ppoll(&task, *server_conn_fd, Events::IN);
// src: litebox_shim_linux/src/syscalls/net.rs:4055 | }
// src: litebox_shim_linux/src/syscalls/net.rs:4056 | let n = task
// src: litebox_shim_linux/src/syscalls/net.rs:4057 | .do_recvfrom(*server_conn_fd, &mut buf, ReceiveFlags::empty(), None)
// src: litebox_shim_linux/src/syscalls/net.rs:4058 | .expect("recvfrom failed");
// src: litebox_shim_linux/src/syscalls/net.rs:4059 | assert_eq!(n, msg.len());
// src: litebox_shim_linux/src/syscalls/net.rs:4060 | assert_eq!(&buf[..n], msg.as_bytes());
// src: litebox_shim_linux/src/syscalls/net.rs:4061 | }
    received := received + 1;
// synth: close receive loop body
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4063 | for server_conn_fd in server_conn_fds {
  var closed := 0;
// src: litebox_shim_linux/src/syscalls/net.rs:4063 | for server_conn_fd in server_conn_fds {
  while closed < 10
// synth: closed descriptors form a prefix of the accepted descriptors
    invariant 0 <= closed <= 10
// synth: loop termination metric
    decreases 10 - closed
// synth: close loop body
  {
// src: litebox_shim_linux/src/syscalls/net.rs:4064 | close_socket(&task, server_conn_fd);
// src: litebox_shim_linux/src/syscalls/net.rs:4065 | }
    closed := closed + 1;
// synth: close descriptor loop body
  }
// src: litebox_shim_linux/src/syscalls/net.rs:4066 | close_socket(&task, server_fd);
  serverWorkCompleted := true;
// src: litebox_shim_linux/src/syscalls/net.rs:4067 | client.join().unwrap();
  clientJoined := true;
// src: litebox_shim_linux/src/syscalls/net.rs:4067 | client.join().unwrap();
  joinAfterServerWork := serverWorkCompleted;
// src: litebox_shim_linux/src/syscalls/net.rs:4067 | client.join().unwrap();
  testPanicked := JoinUnwrap(clientPanicked);
// src: litebox_shim_linux/src/syscalls/net.rs:4068 | }
  returnedSuccessfully := !testPanicked;
// synth: close entry body
}
// src: litebox_shim_linux/src/syscalls/net.rs:3982 | let task = init_platform();
// src: litebox_shim_linux/src/syscalls/net.rs:3993 | .unwrap();
method SetupEnvironment(completes: bool) returns (ok: bool)
// synth: abstract result of initialization and server socket creation
  ensures ok == completes
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/net.rs:3993 | .unwrap();
  ok := completes;
// synth: close helper body
}
// src: litebox_shim_linux/src/lib.rs:1311 | /// Spawns a thread that runs with a clone of this task and a new TID.
// src: litebox_shim_linux/src/lib.rs:1313 | /// # Panics
// src: litebox_shim_linux/src/lib.rs:1314 | /// Panics if the test process is already terminating.
// src: litebox_shim_linux/src/lib.rs:1316 | pub(crate) fn spawn_clone_for_test<R>(
method SpawnClient(spawnPanics: bool, eventualClientPanic: bool) returns (handleCreated: bool, panicked: bool)
// synth: captured spawn contract and abstract closure outcome
  ensures handleCreated == !spawnPanics && panicked == (if spawnPanics then false else eventualClientPanic)
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/net.rs:3995 | let client = task.spawn_clone_for_test(move |task| {
  handleCreated := !spawnPanics;
// src: litebox_shim_linux/src/syscalls/net.rs:4029 | });
  panicked := if handleCreated then eventualClientPanic else false;
// synth: close helper body
}
// src: litebox_shim_linux/src/syscalls/net.rs:4031 | let mut server_conn_fds = Vec::new();
method ServerPhaseOutcome(completes: bool) returns (ok: bool)
// synth: abstract combined outcome of server-side calls and assertions
  ensures ok == completes
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/net.rs:4066 | close_socket(&task, server_fd);
  ok := completes;
// synth: close helper body
}
// src: litebox_shim_linux/src/syscalls/net.rs:4067 | client.join().unwrap();
method JoinUnwrap(clientPanicked: bool) returns (panics: bool)
// synth: unwrapping a failed thread join panics
  ensures panics == clientPanicked
// synth: helper body
{
// src: litebox_shim_linux/src/syscalls/net.rs:4067 | client.join().unwrap();
  panics := clientPanicked;
// synth: close helper body
}

method NfvRefuteReachProbe(is_nonblocking: bool, setupCompletes: bool, spawnPanics: bool, serverWorkCompletes: bool, clientPanicsInput: bool) returns (serverWorkCompleted: bool, clientJoined: bool, joinAfterServerWork: bool, clientPanicked: bool, returnedSuccessfully: bool, testPanicked: bool)
  ensures false
{

  serverWorkCompleted := false;

  clientJoined := false;

  joinAfterServerWork := false;

  clientPanicked := false;

  returnedSuccessfully := false;

  testPanicked := false;












  var setupOk := SetupEnvironment(setupCompletes);

  if !setupOk

  {

    testPanicked := true;

    return;

  }

































  var handleCreated: bool;

  handleCreated, clientPanicked := SpawnClient(spawnPanics, clientPanicsInput);

  if !handleCreated

  {

    testPanicked := true;

    return;

  }

  var serverOk := ServerPhaseOutcome(serverWorkCompletes);

  if !serverOk

  {

    testPanicked := true;

    return;

  }

  var accepted := 0;

  while accepted < 10

    invariant 0 <= accepted <= 10

    decreases 10 - accepted

  {
















    accepted := accepted + 1;

  }

  var received := 0;

  while received < 10

    invariant 0 <= received <= 10

    invariant accepted == 10

    decreases 10 - received

  {











    received := received + 1;

  }

  var closed := 0;

  while closed < 10

    invariant 0 <= closed <= 10

    decreases 10 - closed

  {


    closed := closed + 1;

  }

  serverWorkCompleted := true;

  clientJoined := true;

  joinAfterServerWork := serverWorkCompleted;

  testPanicked := JoinUnwrap(clientPanicked);

  returnedSuccessfully := !testPanicked;

}
