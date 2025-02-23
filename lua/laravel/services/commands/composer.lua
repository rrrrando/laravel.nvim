local composer = {}

function composer:new(runner, pickers)
  local instance = {
    runner = runner,
    pickers = pickers,
    sub_commands = {
      "install",
      "require",
      "update",
      "remove",
      "info",
    },
  }
  setmetatable(instance, self)
  self.__index = self

  return instance
end

function composer:commands()
  return { "composer" }
end

function composer:handle(args)
  table.remove(args.fargs, 1)
  if vim.tbl_isempty(args.fargs) then
    if self.pickers:exists('composer') then
      self.pickers:run('composer')
      return
    end

    vim.ui.select(self.sub_commands, { prompt = "Composer commands" }, function(selected)
      if selected == nil then
        return
      end

      self.runner:run("composer", { selected })
    end)
    return
  end
  self.runner:run("composer", args.fargs)
end

function composer:complete(argLead, cmdLine)
  return vim
      .iter(self.sub_commands)
      :filter(function(name)
        return vim.startswith(name, argLead)
      end)
      :totable()
end

return composer
