local _0_0 = nil
do
  local name_0_ = "lispdocs.fetch"
  local loaded_0_ = package.loaded[name_0_]
  local module_0_ = nil
  if ("table" == type(loaded_0_)) then
    module_0_ = loaded_0_
  else
    module_0_ = {}
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = (module_0_["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = (module_0_["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("conjure.aniseed.core"), require("conjure.aniseed.string"), require("lispdocs.util")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {a = "conjure.aniseed.core", str = "conjure.aniseed.string", util = "lispdocs.util"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local str = _local_0_[2]
local util = _local_0_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "lispdocs.fetch"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local get_url = nil
do
  local v_0_ = nil
  local function get_url0(ext)
    local _2_0 = ext
    if (_2_0 == "clj") then
      return "https://clojuredocs.org/clojuredocs-export.json"
    end
  end
  v_0_ = get_url0
  _0_0["aniseed/locals"]["get-url"] = v_0_
  get_url = v_0_
end
local get_tmp_path = nil
do
  local v_0_ = nil
  local function get_tmp_path0(ext)
    local _2_0 = ext
    if (_2_0 == "clj") then
      return "/tmp/cljex.json"
    end
  end
  v_0_ = get_tmp_path0
  _0_0["aniseed/locals"]["get-tmp-path"] = v_0_
  get_tmp_path = v_0_
end
local dl_msg = nil
do
  local v_0_ = nil
  local function dl_msg0(ext)
    return str.join(" ", {"lspdocs.nvim: Caching data for", ext, "....."})
  end
  v_0_ = dl_msg0
  _0_0["aniseed/locals"]["dl-msg"] = v_0_
  dl_msg = v_0_
end
local dl_err = nil
do
  local v_0_ = nil
  local function dl_err0(ext)
    return str.join(" ", {"lspdocs.nvim: Couldn't download data for ", ext, " processing,", "try again or report issue."})
  end
  v_0_ = dl_err0
  _0_0["aniseed/locals"]["dl-err"] = v_0_
  dl_err = v_0_
end
local dl_succ = nil
do
  local v_0_ = nil
  local function dl_succ0(ext)
    return str.join(" ", {"lispdocs.nvim: data for", ext, "has been downloaded successfully."})
  end
  v_0_ = dl_succ0
  _0_0["aniseed/locals"]["dl-succ"] = v_0_
  dl_succ = v_0_
end
local tmp_file_exists_3f = nil
do
  local v_0_ = nil
  local function tmp_file_exists_3f0(ext)
    local path = get_tmp_path(ext)
    return (util["exists?"](path) and (vim.loop.fs_stat(path).size > 1700))
  end
  v_0_ = tmp_file_exists_3f0
  _0_0["aniseed/locals"]["tmp-file-exists?"] = v_0_
  tmp_file_exists_3f = v_0_
end
local download = nil
do
  local v_0_ = nil
  local function download0(ext)
    local downloaded = nil
    if not tmp_file_exists_3f(ext) then
      local function _2_()
        if tmp_file_exists_3f(ext) then
          downloaded = true
          return nil
        else
          downloaded = false
          return nil
        end
      end
      vim.fn.jobstart({"curl", "-L", get_url(ext), "-o", get_tmp_path(ext)}, {on_exit = _2_})
      local function _3_()
        return ((downloaded == true) or (downloaded == false))
      end
      vim.wait(100000, _3_)
      assert(downloaded, dl_err(ext))
      return print(dl_succ(ext))
    end
  end
  v_0_ = download0
  _0_0["aniseed/locals"]["download"] = v_0_
  download = v_0_
end
local data = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function data0(ext)
      local path = get_tmp_path(ext)
      local valid = tmp_file_exists_3f(ext)
      if not valid then
        print(dl_msg(ext))
        download(ext)
      end
      local file = io.open(path)
      local json = file:read("*all")
      file:close()
      return vim.fn.json_decode(json)
    end
    v_0_0 = data0
    _0_0["data"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["data"] = v_0_
  data = v_0_
end
return nil