Describe 'Hosts file resource tests' {
    Context 'A hosts file entry does not exist. It should.' {
        It 'Get function should return Ensure as absent.' {

        }

        It 'Test function should return false.' {

        }

        It 'Set function should add the hosts file entry.' {

        }
    }

    Context 'A hosts file entry exists as it should.' {
        It 'Get function should return Ensure as present.' {

        }

        It 'Test function should return true.' {

        }
    }

    Context 'A hosts file entry exists and it should not.' {
        It 'Get function should return Ensure as present.' {

        }

        It 'Test function should return false.' {

        }

        It 'Set function should call Set-Content only once.' {

        }
    }

    Context 'A hosts file entry does not exist and it should not.' {
        It 'Get function should return Ensure as absent.' {

        }

        It 'Test function should return true.' {

        }
    }
}
