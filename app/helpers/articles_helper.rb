module ArticlesHelper
    # the URL of this website
    def site_url
        return ContactInfo.site_url if defined? ContactInfo
        'https://www.bar.org/'
    end

    # Contact email address
    def editor_email
        return ContactInfo.editor_email if defined? ContactInfo
        'info@bar.org'
    end

    # the signature of Editor in Chief
    def chiefs_signature
        return ContactInfo.chiefs_signature if defined? ContactInfo
        <<EOT
        <p>某会 編集委員長<br/>
        某　なにがし</p>

        <p>〒000-0000 某市某所<br/>
        某組織 某部署<br/>
        E-mail: foo@bar.org</p>
EOT
    end
end
