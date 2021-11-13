export PIPEWIRE_RUNTIME_DIR=/home/udit/.local/run/pipewire
export XDG_STATE_HOME=/home/udit/.local/lib

if [ "$(ps -au udit | grep -i pipewire | awk '{print $4}' | head -n 2 | head -n 1)" != "pipewire" ]; then
	pipewire &
	disown pipewire
fi

if [ "$(ps -au udit | grep -i pipewire | awk '{print $4}' | head -n 2 | tail -n 1)" != "pipewire-pulse" ]; then
	pipewire-pulse &
	disown pipewire-pulse
fi
