return {
	-- Main avante.nvim plugin
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- Set to "*" for latest release, false for latest code
		build = "make",

		-- LazyVim will merge this with your existing dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The following are optional dependencies
			"hrsh7th/nvim-cmp", -- autocompletion
			"nvim-tree/nvim-web-devicons", -- icons
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
					},
				},
			},
			--{
			--	"MeanderingProgrammer/render-markdown.nvim",
			--	opts = {
			--		file_types = { "markdown", "Avante" },
			--	},
			--	ft = { "markdown", "Avante" },
			--},
		},

		opts = {
			-- Provider setup
			provider = "deepseek", -- Set DeepSeek as the default provider

			providers = {
				-- Built-in providers can be overridden here if needed
				openai = {
					endpoint = "https://api.openai.com/v1",
					model = "gpt-4",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.7,
						max_tokens = 4096,
						stop = {
							"Let me also check",
							"Let me also",
							"Let me test by",
							"Let me update the",
						},
					},
				},

				-- Custom DeepSeek provider (formerly in 'vendors')
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com/v1",
					model = "deepseek-chat",
					context_window = 120000, -- Deepseek-chat has 128K context, set slightly lower for safety

					-- Request body parameters go in extra_request_body
					extra_request_body = {
						temperature = 0.3,
						max_tokens = 2048,
						-- DeepSeek specific parameters if any
					},

					-- Disable tools if not needed
					disable_tools = false,
				},

				-- You can add multiple variants
				["deepseek-coder"] = {
					__inherited_from = "deepseek",
					model = "deepseek-coder",
					extra_request_body = {
						temperature = 0.2, -- Lower temperature for more precise coding
						max_tokens = 4096, -- More tokens for code generation
					},
				},
			},

			-- ACP (Agent Client Protocol) providers configuration
			acp_providers = {
				["gemini-cli"] = {
					command = "gemini",
					args = { "--experimental-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
					},
				},
				["claude-code"] = {
					command = "npx",
					args = { "@zed-industries/claude-code-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
					},
				},
				["goose"] = {
					command = "goose",
					args = { "acp" },
				},
				["codex"] = {
					command = "npx",
					args = { "@zed-industries/codex-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
					},
				},
				["kimi-cli"] = {
					command = "kimi",
					args = { "acp" },
					env = {
						MOONSHOT_API_KEY = os.getenv("MOONSHOT_API_KEY"),
					},
				},
			},

			-- RAG Service configuration
			rag_service = {
				enabled = false, -- Enable RAG service with Ollama embeddings
				host_mount = os.getenv("HOME"), -- Mount home directory for file access
				runner = "podman", -- Use Podman instead of Docker
				llm = {
					provider = "ollama", -- LLM provider for RAG (OpenAI-compatible)
					endpoint = "http://localhost:11434", -- Ollama OpenAI-compatible endpoint
					api_key = "", -- Ollama doesn't require API key locally
					model = "llama2", -- Ollama model for chat/completion
					extra = {
						temperature = 0.7,
						max_tokens = 4096,
					},
				},
				embed = {
					provider = "ollama", -- Embedding provider (OpenAI-compatible)
					endpoint = "http://localhost:11434", -- Ollama OpenAI-compatible endpoint
					api_key = "", -- Ollama doesn't require API key locally
					model = "nomic-embed-text", -- Ollama embedding model
					extra = {
						embed_batch_size = 10,
					},
				},
				docker_extra_args = "", -- Additional Docker arguments
			},

			-- Behavior customization
			behaviour = {
				auto_suggestions = false, -- Disable auto-suggestions if they're annoying
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				support_paste_from_clipboard = true,
			},

			-- Window layout
			windows = {
				wrap = true,
				width = 26, -- slightly wider feels better with code

				sidebar = {
					height = 40, -- 👈 big chat area
				},

				input = {
					height = 10, -- 👈 larger input + todos
				},

				edit = {
					border = "rounded",
				},

				ask = {
					border = "rounded",
				},
			},

			-- Mappings (customize to avoid conflicts with LazyVim defaults)
			mappings = {
				--- @class AvanteConflictMappings
				ask = "<leader>aa", -- Ask avante
				edit = "<leader>ae", -- Edit based on selected
				refresh = "<leader>ar", -- Refresh sidebar
				focus = "<leader>af", -- Focus on avante sidebar
				stop = "<leader>as", -- Stop avante
				chat_new = "<leader>ac", -- New chat window

				-- These are less likely to conflict with LazyVim
				sidebar = {
					apply_text = "<C-CR>",
					retry = "<C-r>",
					close = "q",
				},
			},

			-- Custom tools for avante.nvim
			custom_tools = {
				{
					name = "neovim_messages",
					description = "Get Neovim message history (equivalent to :messages command)",
					param = {
						type = "table",
						fields = {
							{
								name = "lines",
								description = "Number of lines to retrieve (optional, default: all)",
								type = "integer",
								optional = true,
							},
						},
					},
					returns = {
						{
							name = "messages",
							description = "The Neovim message history",
							type = "string",
						},
						{
							name = "error",
							description = "Error message if retrieval failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local lines = params.lines or 0 -- 0 means all lines

						-- Get messages using vim.fn.execute()
						-- The 'messages' command returns the message history
						local messages = vim.fn.execute("messages")

						-- If lines parameter is specified, get only last N lines
						if lines > 0 then
							local all_lines = {}
							for line in messages:gmatch("[^\r\n]+") do
								table.insert(all_lines, line)
							end

							-- Get last N lines
							local start_idx = math.max(1, #all_lines - lines + 1)
							local last_lines = {}
							for i = start_idx, #all_lines do
								table.insert(last_lines, all_lines[i])
							end
							messages = table.concat(last_lines, "\n")
						end

						return messages
					end,
				},
				{
					name = "neovim_echo",
					description = "Echo a message in Neovim (for debugging)",
					param = {
						type = "table",
						fields = {
							{
								name = "message",
								description = "Message to echo",
								type = "string",
							},
						},
					},
					returns = {
						{
							name = "result",
							description = "Confirmation message",
							type = "string",
						},
					},
					func = function(params, on_log, on_complete)
						local message = params.message or ""
						vim.notify("Avante Debug: " .. message, vim.log.levels.INFO)
						return "Message echoed: " .. message
					end,
				},
				{
					name = "dotfiles_stow",
					description = "Manage dotfiles with GNU Stow (symlink files to home directory) - ONLY for dotfiles repository",
					param = {
						type = "table",
						fields = {
							{
								name = "operation",
								description = "Stow operation to perform: 'stow' (default), 'unstow', 'restow', 'status', or 'help'",
								type = "string",
								optional = true,
								default = "stow",
							},
							{
								name = "target",
								description = "Specific target to stow (optional, defaults to current directory '.')",
								type = "string",
								optional = true,
								default = ".",
							},
							{
								name = "dry_run",
								description = "Perform dry run without making changes (optional)",
								type = "boolean",
								optional = true,
								default = false,
							},
						},
					},
					returns = {
						{
							name = "output",
							description = "Output from the stow command",
							type = "string",
						},
						{
							name = "success",
							description = "Whether the operation was successful",
							type = "boolean",
						},
						{
							name = "error",
							description = "Error message if operation failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local operation = params.operation or "stow"
						local target = params.target or "."
						local dry_run = params.dry_run or false

						-- Check if we're in a dotfiles repository
						-- Look for markers that indicate this is a dotfiles repo
						local current_dir = vim.fn.getcwd()
						local is_dotfiles_repo = false

						-- Check for common dotfiles repository markers
						local markers = {
							".avante/rules", -- Our project-specific rules directory
							".config/nvim", -- Neovim configuration
							".config/hypr", -- Hyprland configuration
							".config/waybar", -- Waybar configuration
							"README.md", -- Repository README
						}

						for _, marker in ipairs(markers) do
							local marker_path = current_dir .. "/" .. marker
							if vim.fn.filereadable(marker_path) == 1 or vim.fn.isdirectory(marker_path) == 1 then
								is_dotfiles_repo = true
								break
							end
						end

						-- Also check if we're in ~/.dotfiles directory
						local home_dir = os.getenv("HOME")
						if home_dir and current_dir == home_dir .. "/.dotfiles" then
							is_dotfiles_repo = true
						end

						if not is_dotfiles_repo then
							return nil,
								false,
								"This tool is only available in dotfiles repositories. Current directory doesn't appear to be a dotfiles repository."
						end

						-- Validate operation
						local valid_operations = {
							["stow"] = true,
							["unstow"] = true,
							["restow"] = true,
							["status"] = true,
							["help"] = true,
						}

						if not valid_operations[operation] then
							return nil,
								false,
								"Invalid operation: "
									.. operation
									.. ". Valid operations: stow, unstow, restow, status, help"
						end

						-- Build command
						local cmd = "stow"
						local args = {}

						if operation == "stow" then
							table.insert(args, "-v")
							if dry_run then
								table.insert(args, "-n")
							end
							-- Add ignore patterns when stowing from root to exclude repository files
							if target == "." then
								table.insert(args, "--ignore='^\\.avante'")
								table.insert(args, "--ignore='^\\.git'")
								table.insert(args, "--ignore='^AGENTS\\.md$'")
								table.insert(args, "--ignore='^README\\.md$'")
								table.insert(args, "--ignore='^avant-analysis\\.md$'")
								table.insert(args, "--ignore='^\\.gitignore$'")
								table.insert(args, "--ignore='^\\.stow-local-ignore$'")
							end
							table.insert(args, target)
						elseif operation == "unstow" then
							table.insert(args, "-v")
							table.insert(args, "-D")
							if dry_run then
								table.insert(args, "-n")
							end
							-- Add ignore patterns when unstowing from root
							if target == "." then
								table.insert(args, "--ignore='^\\.avante'")
								table.insert(args, "--ignore='^\\.git'")
								table.insert(args, "--ignore='^AGENTS\\.md$'")
								table.insert(args, "--ignore='^README\\.md$'")
								table.insert(args, "--ignore='^avant-analysis\\.md$'")
								table.insert(args, "--ignore='^\\.gitignore$'")
								table.insert(args, "--ignore='^\\.stow-local-ignore$'")
							end
							table.insert(args, target)
						elseif operation == "restow" then
							table.insert(args, "-v")
							table.insert(args, "-R")
							if dry_run then
								table.insert(args, "-n")
							end
							-- Add ignore patterns when restowing from root
							if target == "." then
								table.insert(args, "--ignore='^\\.avante'")
								table.insert(args, "--ignore='^\\.git'")
								table.insert(args, "--ignore='^AGENTS\\.md$'")
								table.insert(args, "--ignore='^README\\.md$'")
								table.insert(args, "--ignore='^\\.gitignore$'")
								table.insert(args, "--ignore='^\\.stow-local-ignore$'")
							end
							table.insert(args, target)
						elseif operation == "status" then
							table.insert(args, "-v")
							table.insert(args, "--no")
							table.insert(args, target)
						elseif operation == "help" then
							cmd = "stow --help"
							args = {}
						end

						-- Execute command
						local full_cmd = cmd .. " " .. table.concat(args, " ")
						local handle = io.popen(full_cmd .. " 2>&1", "r")

						if not handle then
							return nil, "Failed to execute stow command"
						end

						local output = handle:read("*a")
						handle:close()

						-- Check if stow command exists
						if output:match("command not found") or output:match("not found") then
							return output,
								"GNU Stow is not installed. Install with: sudo apt install stow (Debian/Ubuntu) or sudo pacman -S stow (Arch)"
						end

						-- Determine success
						local success = true
						if output:match("ERROR") or output:match("error") then
							success = false
						end

						-- Add notification for user
						if operation ~= "help" and operation ~= "status" and not dry_run then
							local message = "Stow operation completed: " .. operation
							if target ~= "." then
								message = message .. " on " .. target
							end
							vim.notify(message, success and vim.log.levels.INFO or vim.log.levels.ERROR)
						end

						return output, success, not success and "Stow operation failed" or nil
					end,
				},
				{
					name = "create_session_log",
					description = "Create a new session log file with timestamp and metadata",
					param = {
						type = "table",
						fields = {
							{
								name = "title",
								description = "Session title (required)",
								type = "string",
							},
							{
								name = "participants",
								description = "Session participants (optional, defaults to current user)",
								type = "string",
								optional = true,
								default = "Geoff",
							},
							{
								name = "project",
								description = "Project name/ID (optional)",
								type = "string",
								optional = true,
								default = "Current Project",
							},
							{
								name = "tags",
								description = "Session tags (optional, comma-separated)",
								type = "string",
								optional = true,
								default = "session,log",
							},
							{
								name = "duration",
								description = "Session duration (optional)",
								type = "string",
								optional = true,
								default = "1 hour",
							},
						},
					},
					returns = {
						{
							name = "filepath",
							description = "Path to the created session log file",
							type = "string",
						},
						{
							name = "success",
							description = "Whether the session log was created successfully",
							type = "boolean",
						},
						{
							name = "error",
							description = "Error message if creation failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local title = params.title or "Untitled Session"
						local participants = params.participants or "Geoff"
						local project = params.project or "Current Project"
						local tags_input = params.tags or "session,log"
						local duration = params.duration or "1 hour"

						-- Parse tags into array format
						local parsed_tags = {}
						if tags_input then
							for tag in tags_input:gmatch("[^,]+") do
								table.insert(parsed_tags, (tag:gsub("^%s*(.-)%s*$", "%1")))
							end
						end

						-- Get current timestamp
						local now = os.time()
						local timestamp = os.date("%Y%m%d-%H%M%S", now)
						local date_str = os.date("%Y-%m-%d", now)
						local time_str = os.date("%H:%M:%S", now)

						-- Create filename (sanitize title for filename)
						local safe_title = title:gsub("[^%w%s%-]", ""):gsub("%s+", "-"):lower()
						local filename = timestamp .. "-" .. safe_title .. ".md"

						-- Check if .avante/context/sessions directory exists
						local current_dir = vim.fn.getcwd()
						local sessions_dir = current_dir .. "/.avante/context/sessions"
						local template_path = vim.fn.stdpath("config") .. "/avante/templates/session-log_TEMPLATE.md"
						local filepath = sessions_dir .. "/" .. filename

						-- Check if .avante structure exists
						if vim.fn.isdirectory(current_dir .. "/.avante") == 0 then
							return nil,
								false,
								"No .avante directory found. This tool requires the standardized .avante/ structure."
						end

						-- Check if sessions directory exists, create if not

						if vim.fn.isdirectory(sessions_dir) == 0 then
							vim.fn.mkdir(sessions_dir, "p")
						end

						-- Check if template exists
						if vim.fn.filereadable(template_path) == 0 then
							return nil, "Session template not found at: " .. template_path
						end

						-- Read template
						local template_content = ""
						local template_file = io.open(template_path, "r")

						if template_file then
							template_content = template_file:read("*a")
							template_file:close()
						else
							return nil, false, "Failed to read session template"
						end

						-- Replace template placeholders with actual values
						local session_content = template_content
							:gsub("%[Session Title%]", title)
							:gsub("%[YYYYMMDD%-HHMMSS%]", timestamp)
							:gsub("%[YYYY%-MM%-DD%]", date_str)
							:gsub("%[HH:MM:SS%]", time_str)
							:gsub("%[X hours/minutes%]", duration)
							:gsub("%[Names/Roles%]", participants)
							:gsub("%[Project Name/ID%]", project)
							:gsub("%[session, log, meeting, work%-session%]", table.concat(parsed_tags, ", "))
							:gsub("%[YYYY%-MM%-DD HH:MM:SS%]", date_str .. " " .. time_str)

						-- Write session log file
						local session_file = io.open(filepath, "w")
						if not session_file then
							return nil, false, "Failed to create session log file: " .. filepath
						end

						session_file:write(session_content)
						session_file:close()

						-- Notify user
						vim.notify("Session log created: " .. filename, vim.log.levels.INFO)

						return filepath, nil
					end,
				},
				{
					name = "k8s_status",
					description = "Get a quick overview of the Kubernetes cluster: node health, pod counts per namespace, any non-running pods, and recent events",
					param = {
						type = "table",
						fields = {
							{
								name = "namespace",
								description = "Filter to a specific namespace (optional, shows all namespaces by default)",
								type = "string",
								optional = true,
							},
							{
								name = "show_events",
								description = "Show recent cluster events (default: true)",
								type = "boolean",
								optional = true,
								default = true,
							},
						},
					},
					returns = {
						{
							name = "output",
							description = "Formatted cluster status overview",
							type = "string",
						},
						{
							name = "error",
							description = "Error message if the command failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local namespace = params.namespace or ""
						local show_events = params.show_events
						if show_events == nil then
							show_events = true
						end
						local ns_flag = ""
						if namespace ~= "" then
							ns_flag = " -n " .. vim.fn.shellescape(namespace)
						end
						local result = {}
						table.insert(result, "=== KUBERNETES CLUSTER STATUS ===")
						table.insert(result, "")
						table.insert(result, "--- Nodes ---")
						local node_handle = io.popen("kubectl get nodes -o wide 2>&1", "r")
						if node_handle then
							local node_output = node_handle:read("*a")
							node_handle:close()
							if node_output:match("command not found") then
								return nil, "kubectl is not installed or not in PATH"
							end
							table.insert(result, node_output)
						end
						table.insert(result, "")
						table.insert(result, "--- Pod Summary ---")
						local pod_cmd = "kubectl get pods" .. ns_flag .. " --all-namespaces --no-headers 2>&1"
						local pod_handle = io.popen(pod_cmd, "r")
						if pod_handle then
							local pod_output = pod_handle:read("*a")
							pod_handle:close()
							local ns_pods = {}
							local non_running = {}
							local total_pods = 0
							for line in pod_output:gmatch("[^\r\n]+") do
								local ns, name, ready, status, restarts, age =
									line:match("^(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
								if ns then
									ns_pods[ns] = (ns_pods[ns] or 0) + 1
									total_pods = total_pods + 1
									if status ~= "Running" and status ~= "Completed" then
										table.insert(non_running, line)
									end
								end
							end
							table.insert(result, "Total pods: " .. total_pods)
							table.insert(result, "")
							table.insert(result, "Pods per namespace:")
							for ns, count in pairs(ns_pods) do
								table.insert(result, "  " .. ns .. ": " .. count)
							end
							if #non_running > 0 then
								table.insert(result, "")
								table.insert(result, "Non-running pods:")
								for _, line in ipairs(non_running) do
									table.insert(result, "  " .. line)
								end
							else
								table.insert(result, "")
								table.insert(result, "All pods are running or completed.")
							end
						end
						table.insert(result, "")
						if show_events then
							table.insert(result, "--- Recent Events (last 15) ---")
							local events_cmd = "kubectl get events"
								.. ns_flag
								.. " --all-namespaces --sort-by='.lastTimestamp' --no-headers 2>&1 | tail -15"
							local events_handle = io.popen(events_cmd, "r")
							if events_handle then
								local events_output = events_handle:read("*a")
								events_handle:close()
								if events_output ~= "" then
									table.insert(result, events_output)
								else
									table.insert(result, "  No recent events.")
								end
							end
						end
						return table.concat(result, "\n")
					end,
				},

				{
					name = "k8s_logs",
					description = "Tail logs from a Kubernetes pod with namespace and container selection",
					param = {
						type = "table",
						fields = {
							{
								name = "namespace",
								description = "Namespace of the pod (required)",
								type = "string",
							},
							{
								name = "pod",
								description = "Name of the pod (required)",
								type = "string",
							},
							{
								name = "container",
								description = "Container name within the pod (optional, for multi-container pods)",
								type = "string",
								optional = true,
							},
							{
								name = "tail",
								description = "Number of recent log lines to show (default: 50, use 0 for all)",
								type = "integer",
								optional = true,
								default = 50,
							},
							{
								name = "previous",
								description = "Show logs from the previous instance of the pod (default: false)",
								type = "boolean",
								optional = true,
								default = false,
							},
						},
					},
					returns = {
						{
							name = "output",
							description = "Log output from the pod",
							type = "string",
						},
						{
							name = "error",
							description = "Error message if the command failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local namespace = params.namespace or ""
						local pod = params.pod or ""
						local container = params.container or ""
						local tail = params.tail
						if tail == nil then
							tail = 50
						end
						local previous = params.previous or false
						if namespace == "" then
							return nil, "Namespace is required"
						end
						if pod == "" then
							return nil, "Pod name is required"
						end
						local cmd = "kubectl logs -n "
							.. vim.fn.shellescape(namespace)
							.. " "
							.. vim.fn.shellescape(pod)
						if container ~= "" then
							cmd = cmd .. " -c " .. vim.fn.shellescape(container)
						end
						if tail > 0 then
							cmd = cmd .. " --tail=" .. tail
						end
						if previous then
							cmd = cmd .. " --previous"
						end
						cmd = cmd .. " 2>&1"
						local handle = io.popen(cmd, "r")
						if not handle then
							return nil, "Failed to execute kubectl logs command"
						end
						local output = handle:read("*a")
						handle:close()
						if output:match("command not found") then
							return nil, "kubectl is not installed or not in PATH"
						end
						if output == "" then
							return "No log output returned. The pod may not have started or may have no logs yet."
						end
						return output
					end,
				},

				{
					name = "k8s_describe",
					description = "Describe a Kubernetes resource (pod, service, deployment, node, pvc, etc.) with detailed information",
					param = {
						type = "table",
						fields = {
							{
								name = "resource",
								description = "Resource type (e.g., pod, service, deployment, node, pvc, ingress, configmap, secret, namespace)",
								type = "string",
							},
							{
								name = "name",
								description = "Name of the resource",
								type = "string",
							},
							{
								name = "namespace",
								description = "Namespace of the resource (optional, not needed for cluster-scoped resources like nodes)",
								type = "string",
								optional = true,
							},
						},
					},
					returns = {
						{
							name = "output",
							description = "Detailed resource description",
							type = "string",
						},
						{
							name = "error",
							description = "Error message if the command failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local resource = params.resource or ""
						local name = params.name or ""
						local namespace = params.namespace or ""
						if resource == "" then
							return nil, "Resource type is required (e.g., pod, service, deployment, node, pvc)"
						end
						if name == "" then
							return nil, "Resource name is required"
						end
						local cmd = "kubectl describe "
							.. vim.fn.shellescape(resource)
							.. " "
							.. vim.fn.shellescape(name)
						if namespace ~= "" then
							cmd = cmd .. " -n " .. vim.fn.shellescape(namespace)
						end
						cmd = cmd .. " 2>&1"
						local handle = io.popen(cmd, "r")
						if not handle then
							return nil, "Failed to execute kubectl describe command"
						end
						local output = handle:read("*a")
						handle:close()
						if output:match("command not found") then
							return nil, "kubectl is not installed or not in PATH"
						end
						return output
					end,
				},

				{
					name = "k8s_events",
					description = "Show recent Kubernetes cluster events sorted by time, filterable by namespace and severity",
					param = {
						type = "table",
						fields = {
							{
								name = "namespace",
								description = "Filter to a specific namespace (optional, shows all namespaces by default)",
								type = "string",
								optional = true,
							},
							{
								name = "tail",
								description = "Number of recent events to show (default: 20)",
								type = "integer",
								optional = true,
								default = 20,
							},
							{
								name = "warnings_only",
								description = "Show only warning and error events (default: false)",
								type = "boolean",
								optional = true,
								default = false,
							},
						},
					},
					returns = {
						{
							name = "output",
							description = "Formatted event list",
							type = "string",
						},
						{
							name = "error",
							description = "Error message if the command failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local namespace = params.namespace or ""
						local tail = params.tail
						if tail == nil then
							tail = 20
						end
						local warnings_only = params.warnings_only or false
						local ns_flag = ""
						if namespace ~= "" then
							ns_flag = " -n " .. vim.fn.shellescape(namespace)
						end
						local type_filter = ""
						if warnings_only then
							type_filter = " --field-selector type=Warning"
						end
						local cmd = "kubectl get events"
							.. ns_flag
							.. " --all-namespaces --sort-by='.lastTimestamp'"
							.. type_filter
							.. " --no-headers 2>&1 | tail -"
							.. tail
						local handle = io.popen(cmd, "r")
						if not handle then
							return nil, "Failed to execute kubectl get events command"
						end
						local output = handle:read("*a")
						handle:close()
						if output:match("command not found") then
							return nil, "kubectl is not installed or not in PATH"
						end
						if output == "" then
							return "No events found."
						end
						return output
					end,
				},

				{
					name = "k8s_helm",
					description = "List Helm releases and their status across namespaces",
					param = {
						type = "table",
						fields = {
							{
								name = "namespace",
								description = "Filter to a specific namespace (optional, shows all namespaces by default)",
								type = "string",
								optional = true,
							},
							{
								name = "all",
								description = "Show all releases including failed and uninstalled (default: false)",
								type = "boolean",
								optional = true,
								default = false,
							},
						},
					},
					returns = {
						{
							name = "output",
							description = "Formatted Helm release list",
							type = "string",
						},
						{
							name = "error",
							description = "Error message if the command failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local namespace = params.namespace or ""
						local all = params.all or false
						local ns_flag = ""
						if namespace ~= "" then
							ns_flag = " -n " .. vim.fn.shellescape(namespace)
						else
							ns_flag = " --all-namespaces"
						end
						local all_flag = ""
						if all then
							all_flag = " --all"
						end
						local cmd = "helm list" .. ns_flag .. all_flag .. " 2>&1"
						local handle = io.popen(cmd, "r")
						if not handle then
							return nil, "Failed to execute helm list command"
						end
						local output = handle:read("*a")
						handle:close()
						if output:match("command not found") then
							return nil, "helm is not installed or not in PATH"
						end
						if output == "" or output:match("No resources found") then
							return "No Helm releases found."
						end
						return output
					end,
				},

				{
					name = "k8s_storage",
					description = "Show Kubernetes storage overview: PersistentVolumeClaims and PersistentVolumes with status and capacity",
					param = {
						type = "table",
						fields = {
							{
								name = "namespace",
								description = "Filter PVCs to a specific namespace (optional, shows all namespaces by default)",
								type = "string",
								optional = true,
							},
							{
								name = "show_pv",
								description = "Show PersistentVolumes as well (default: true)",
								type = "boolean",
								optional = true,
								default = true,
							},
						},
					},
					returns = {
						{
							name = "output",
							description = "Formatted storage overview",
							type = "string",
						},
						{
							name = "error",
							description = "Error message if the command failed",
							type = "string",
							optional = true,
						},
					},
					func = function(params, on_log, on_complete)
						local namespace = params.namespace or ""
						local show_pv = params.show_pv
						if show_pv == nil then
							show_pv = true
						end
						local result = {}
						table.insert(result, "=== KUBERNETES STORAGE OVERVIEW ===")
						table.insert(result, "")
						local ns_flag = ""
						if namespace ~= "" then
							ns_flag = " -n " .. vim.fn.shellescape(namespace)
						end
						table.insert(result, "--- PersistentVolumeClaims ---")
						local pvc_cmd = "kubectl get pvc" .. ns_flag .. " --all-namespaces 2>&1"
						local pvc_handle = io.popen(pvc_cmd, "r")
						if pvc_handle then
							local pvc_output = pvc_handle:read("*a")
							pvc_handle:close()
							if pvc_output:match("command not found") then
								return nil, "kubectl is not installed or not in PATH"
							end
							table.insert(result, pvc_output)
						end
						table.insert(result, "")
						if show_pv then
							table.insert(result, "--- PersistentVolumes ---")
							local pv_cmd = "kubectl get pv 2>&1"
							local pv_handle = io.popen(pv_cmd, "r")
							if pv_handle then
								local pv_output = pv_handle:read("*a")
								pv_handle:close()
								table.insert(result, pv_output)
							end
							table.insert(result, "")
						end
						table.insert(result, "--- Storage Classes ---")
						local sc_cmd = "kubectl get storageclass 2>&1"
						local sc_handle = io.popen(sc_cmd, "r")
						if sc_handle then
							local sc_output = sc_handle:read("*a")
							sc_handle:close()
							table.insert(result, sc_output)
						end
						return table.concat(result, "\n")
					end,
				},
			},

			-- Rules configuration for avante.nvim
			rules = {
				-- Project-specific rules directory (in current working directory)
				project_dir = ".avante/rules",
				-- Global rules directory (in Neovim config directory)
				global_dir = vim.fn.expand("~/.config/nvim/avante/rules"),
			},
		},

		-- LazyVim will handle the keys specification
		keys = {
			{ "<leader>aa", desc = "Avante: Ask" },
			{ "<leader>ae", desc = "Avante: Edit" },
			{ "<leader>ar", desc = "Avante: Refresh" },
			{ "<leader>af", desc = "Avante: Focus" },
			{ "<leader>as", "<cmd>AvanteStop<cr>", desc = "Avante: Stop" },
			{ "<leader>ac", "<cmd>AvanteChatNew<cr>", desc = "Avante: New Chat" },
		},

		-- Ensure the plugin loads after LazyVim's starter
		init = function()
			-- Monkey-patch rag_service to support podman as a docker-compatible runner.
			-- This avoids modifying plugin files directly, so updates won't overwrite our changes.
			vim.api.nvim_create_autocmd("User", {
				pattern = "AvantePluginLoaded",
				once = true,
				callback = function()
					local ok, rag = pcall(require, "avante.rag_service")
					if ok then
						-- Override get_rag_service_runner to treat podman as docker
						local orig_get_runner = rag.get_rag_service_runner
						rag.get_rag_service_runner = function()
							local runner = (
								require("avante.config").rag_service and require("avante.config").rag_service.runner
							) or "docker"
							if runner == "podman" then
								return "docker"
							end
							return runner
						end
						-- Override get_rag_service_url to use 127.0.0.1 instead of localhost
						-- (avoids potential IPv6 resolution issues with podman)
						rag.get_rag_service_url = function()
							return string.format("http://127.0.0.1:%d", rag.get_rag_service_port())
						end
					end
				end,
			})
		end,
	},

	-- Optional: Add custom keymaps specifically for avante
}
