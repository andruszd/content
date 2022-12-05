# platform = multi_platform_all

{{{ bash_instantiate_variables("var_accounts_tmout") }}}

# if 0, no occurence of tmout found, if 1, occurence found
tmout_found=0

{{%- if product in ["ol7", "rhel7"] %}}
for f in /etc/profile /etc/profile.d/*.sh /etc/bashrc; do
{{% else %}}
for f in /etc/profile /etc/profile.d/*.sh; do
{{% endif %}}
    if grep --silent '^[^#].*TMOUT' $f; then
        sed -i -E "s/^(.*)TMOUT\s*=\s*(\w|\$)*(.*)$/declare -xr TMOUT=$var_accounts_tmout\3/g" $f
        tmout_found=1
    fi
done

if [ $tmout_found -eq 0 ]; then
        echo -e "\n# Set TMOUT to $var_accounts_tmout per security requirements" >> /etc/profile.d/tmout.sh
        echo "declare -xr TMOUT=$var_accounts_tmout" >> /etc/profile.d/tmout.sh
fi
