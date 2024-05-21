module("luci.controller.starvpn", package.seeall)

function index()
  entry({"admin","services",  "starvpn"}, template("starvpn/starvpn"), _("星空组网"), 20).dependent=false
  entry({"admin","services",  "starvpn", "console"}, call("get_console"), nil).leaf = true
  entry({"admin","services",  "starvpn", "check_run_status"}, call("IsServiceRunning"), nil).leaf = true
  entry({"admin","services",  "starvpn", "check_client_status"}, call("client_status"), nil).leaf = true
  entry({"admin","services",  "starvpn", "check_login_status"}, call("isLogin"), nil).leaf = true

  entry({"admin","services",  "starvpn", "login"}, call("login"), nil).leaf = true
  entry({"admin","services",  "starvpn", "logout"}, call("logout"), nil).leaf = true

  entry({"admin","services",  "starvpn", "get_router_ip"}, call("get_router_ip"), nil).leaf = true
  entry({"admin","services",  "starvpn", "start_service"}, call("start_service"), nil).leaf = true
  entry({"admin","services",  "starvpn", "stop_service"}, call("stop_service"), nil).leaf = true
end

function get_console()
  -- 目前为空，你可以根据需要添加更多的逻辑
end

function IsServiceRunning()
  local handle = io.popen("netstat -ltn | grep ':7725'")
  local result = handle:read("*a")
  handle:close()
  luci.http.prepare_content("application/json")
  local response
  if result ~= "" then
    response = {code=0, message="运行中"}
  else
    response = {code=500, message="没有运行"}
  end
  luci.http.write_json(response) -- 使用 write_json 来正确地输出 JSON
end


function login()
  -- 获取账号和密码
  local username = luci.http.formvalue("username")
  local password = luci.http.formvalue("password")
  -- 调用登录接口 form 表单提交，地址：http://127.0.0.1:7725/v1/login
  local command = "curl -s -X POST 'http://127.0.0.1:7725/v1/login' -d 'username=" .. username .. "&password=" .. password .. "'"
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  luci.http.prepare_content("application/json")
  luci.http.write(result)
end

function logout()
  -- 调用登出接口 get请求 ，地址：http://127.0.0.1:7725/v1/logout
  local command = "curl -s 'http://127.0.0.1:7725/v1/logout'"
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  luci.http.prepare_content("application/json")
  luci.http.write(result)
end


function client_status()
  local command = "curl -s 'http://127.0.0.1:7725/v1/cmd/client/status'"
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  luci.http.prepare_content("application/json")
  luci.http.write(result)
end

function isLogin()
  local command = "curl -s 'http://127.0.0.1:7725/v1/is/login'"
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  luci.http.prepare_content("application/json")
  luci.http.write(result)
end


function get_router_ip()
  local ip = tostring(luci.http.getenv("HTTP_HOST")):match("[^:]+")
  luci.http.prepare_content("application/json")
  luci.http.write_json({ ip = ip })
end

function start_service()
  luci.sys.exec("/opt/stars/stars start")
  luci.http.status(200, "Service started")
end

function stop_service()
  luci.sys.exec("/opt/stars/stars stop")
  luci.http.status(200, "Service stopped")
end