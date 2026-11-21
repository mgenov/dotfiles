-- Rex key bindings.
--
-- Rex's own defaults all sit on cmd (cmd+d split, cmd+t tab, cmd+w close,
-- cmd+k session picker), so nothing here needs a tmux-style prefix and ctrl+a
-- stays with the shell. Everything below avoids digits, arrows and alt, which
-- are a layer or a combo away on the Corne.
--
-- Keys are named by physical position ([KeyH]) so bindings survive a switch
-- to a non-Latin keyboard layout.

local TERMINAL = "com.superlogical.terminal"

-- ── Pane focus, shared with nvim splits ─────────────────────────────────────
-- Rex sees a key before the program in the pane does, so a plain binding on
-- ctrl+h/j/k/l would take those keys away from nvim. Hand the key to nvim when
-- it is the foreground program and move Rex focus otherwise.
local function is_vim()
  local p = rex.block.call(TERMINAL, "process")
  local fg = p and p.foreground
  local name = fg and (fg.argv0 or fg.name) or ""
  return name:match("^n?vim$") ~= nil
end

for key, dir in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
  rex.action({
    name = "nav_" .. dir,
    title = "Focus " .. dir .. " (nvim aware)",
    run = function()
      if is_vim() then
        rex.client.queue("pane.send_key", { key = "ctrl+" .. key:lower() })
      else
        rex.client.queue("pane.focus", { direction = dir })
      end
    end,
  })
  rex.bind("ctrl+[Key" .. key .. "]", "nav_" .. dir)
  -- Unconditional variant: the way out of a pane while nvim has the keyboard,
  -- since nvim does not pass the key on at its outermost split.
  rex.bind("ctrl+shift+[Key" .. key .. "]", "pane.focus", { direction = dir })
end

-- ── Tabs across, sessions up and down ───────────────────────────────────────
-- Mirrors the window: tabs run horizontally, the session list vertically.
-- On cmd+shift because both are plain holds on the Corne (thumb and pinky),
-- whereas alt is a two-key combo there. Plain cmd is not an option: macOS
-- owns cmd+h and Rex's session picker sits on cmd+k.
rex.bind("cmd+shift+[KeyH]", "client.tab.previous")
rex.bind("cmd+shift+[KeyL]", "client.tab.next")
rex.bind("cmd+shift+[KeyJ]", "session.next")
rex.bind("cmd+shift+[KeyK]", "session.previous")
rex.bind("cmd+shift+[Semicolon]", "session.back")

-- ── Resize ──────────────────────────────────────────────────────────────────
-- Rex has no key-repeat timer, so resizing is a mode: h/j/k/l resize until
-- escape or enter leaves it.
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+shift+[KeyR]", "client.mode.enter", { name = "resize" })
rex.bind("resize/escape", "client.mode.exit")
rex.bind("resize/enter", "client.mode.exit")
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("resize/" .. key, "pane.resize", { direction = dir })
end

-- ── Project picker ──────────────────────────────────────────────────────────
-- One session per project, named after its directory, so picking a project
-- that is already open switches to it instead of opening a duplicate.

-- Candidates: every directory directly under ~/work, repositories one level
-- deeper (grouping folders such as ~/work/<org>/<repo>), and the dotfiles.
local function project_dirs()
  local listing = rex.exec({
    "sh",
    "-c",
    [[{ find "$HOME/work" -mindepth 1 -maxdepth 1 -type d;
        find "$HOME/work" -mindepth 2 -maxdepth 2 -name .git | sed 's|/\.git$||';
        [ -d "$HOME/dotfiles" ] && echo "$HOME/dotfiles"; } 2>/dev/null | sort -u]],
  })
  local dirs = {}
  for line in listing.stdout:gmatch("[^\n]+") do
    dirs[#dirs + 1] = line
  end
  return dirs
end

-- rex.ui.pick's answer is read loosely (a bare id, a list of ids, or a table
-- holding either) because its exact shape is not documented for this preview.
local function picked_id(answer)
  if type(answer) == "string" then
    return answer
  end
  if type(answer) == "table" then
    local first = answer.id or answer[1] or (answer.ids and answer.ids[1])
    return picked_id(first)
  end
  return nil
end

local function session_named(label)
  local listing = rex.call("session.list")
  for _, s in ipairs(listing and listing.sessions or {}) do
    if s.label == label then
      return s.session_id
    end
  end
  return nil
end

-- Switches to the session for a project directory, creating it with a shell
-- there when it is not open yet.
local function open_project(path)
  local label = path:match("([^/]+)/*$"):gsub("[. ]", "_")
  local session_id = session_named(label)
  if not session_id then
    local created = rex.call("session.create", {
      label = label,
      initial_windows = {
        {
          window_label = "shell",
          layout = { block = { flavor = TERMINAL .. ".shell", options = { cwd = path } } },
        },
      },
    })
    session_id = created.session_id
  end
  rex.client.queue("session.select", { session_id = session_id })
end

rex.action({
  name = "sessionizer",
  title = "Open Project…",
  run = function()
    local path = picked_id(rex.ui.pick({ title = "Project", items = project_dirs() }))
    if path then
      open_project(path)
    end
  end,
})
rex.bind("cmd+shift+[KeyO]", "sessionizer")

-- ── Daily-driver sessions ───────────────────────────────────────────────────
-- cmd+shift+g ("go") followed by a letter jumps straight to a fixed project,
-- replacing tmux's prefix+digit jumps with keys that need no number layer.
-- Paths are relative to $HOME.
local daily = {
  { key = "M", path = "work/monorepo" },
  { key = "B", path = "work/monorepo-mobile" },
  { key = "G", path = "work/gridhelm" },
  { key = "N", path = "work/notes" },
  { key = "C", path = "work/cloud-infra" },
  { key = "F", path = "work/fleet-infra" },
  { key = "D", path = "dotfiles" },
  { key = "L", path = "work/learn" },
}

for _, project in ipairs(daily) do
  local name = project.path:match("[^/]+$")
  -- Action names may not contain dots or dashes.
  local action = "go_" .. name:gsub("[^%w]", "_")
  rex.action({
    name = action,
    title = "Go to " .. name,
    run = function()
      open_project(os.getenv("HOME") .. "/" .. project.path)
    end,
  })
  rex.bind("cmd+shift+[KeyG]>[Key" .. project.key .. "]", action)
end

