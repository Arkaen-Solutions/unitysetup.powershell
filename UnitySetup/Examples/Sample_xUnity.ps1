<#
    Create a custom configuration by passing in necessary values
#>
Configuration Sample_xUnity {
    param 
    (       
        [System.String]
        $Version = '2022.2.20f1',

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [System.String[]]
        $Components = @('Windows', 'Mac', 'Linux', 'UWP', 'iOS', 'Android'),

        [PSCredential]
        $UnityCredential,

        [PSCredential]
        $UnitySerial
    )

    Import-DscResource -ModuleName UnitySetup

    Node 'localhost' {

        xUnitySetupInstance Unity {
            Versions   = $Version
            Components = $Components
            Ensure     = $Ensure
            DependsOn  = if( $Ensure -eq 'Absent' ) { '[xUnityLicense]UnityLicense' } else { $null }
        }

        xUnityLicense UnityLicense {
            Name = 'UL01'
            Credential = $UnityCredential
            Serial = $UnitySerial
            Ensure = $Ensure
            UnityVersion = $Version
            DependsOn = if( $Ensure -eq 'Present' ) { '[xUnitySetupInstance]Unity' } else { $null }
        }
    }
}