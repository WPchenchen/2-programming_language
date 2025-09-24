## 总结图（按场景分类）：

| 场景          | 通信方式                   | 推荐模块              |
| ------------- | -------------------------- | --------------------- |
| 线程内通信    | Queue, Lock, Event         | `threading`, `queue`  |
| 本地进程通信  | Pipe, Queue, Shared Memory | `multiprocessing`     |
| 网络通信      | TCP/UDP                    | `socket`, `asyncio`   |
| Web 通信      | HTTP, WebSocket            | `requests`, `aiohttp` |
| 异步任务/队列 | 消息队列（MQ）             | `Celery`, `pyzmq`     |
| 远程服务调用  | RPC/gRPC                   | `grpcio`, `rpyc`      |
| 简单共享      | 文件、数据库               | `sqlite3`, `json`     |