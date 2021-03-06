if [ -e ~/.kvm-auto ]; then
for vm in $(echo $(cat ~/.kvm-auto | grep '^[^#]')); do
	if [ -e ~/.kvm-state/${vm} ]; then
		virsh restore ~/.kvm-state/${vm}
		rm -f ~/.kvm-state/${vm}
	elif [ "x$(virsh domstate ${vm})" = "xshut off" ]; then
		virsh start ${vm}
	fi
done
fi

if [ -e ~/.vbox-auto ]; then
for vm in $(echo $(cat ~/.vbox-auto | grep '^[^#]')); do
	VBoxManage startvm ${vm} --type headless
done
fi
