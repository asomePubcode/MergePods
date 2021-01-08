module LdsHttp
    def LdsHttp.localDependency(s,superDependency)
        if superDependency.nil?
            s.dependency 'LdsLogger'
            # s.dependency 'LdsCore'
        else 
            s.dependency "#{superDependency}/LdsLogger"
            # s.dependency "#{superDependency}/LdsCore"
        end
    end
    def LdsHttp.netDependency(s)
        s.dependency 'AFNetworking'
    end
    def LdsHttp.config(spec,sourcePath,superDependency)
        spec.ios.deployment_target = '9.0'
        spec.source_files = "#{sourcePath}Classes/**/*"
        # spec.public_header_files = "#{sourcePath}Classes/*.h"
        puts "#{sourcePath}Classes/**/*-----"
        self.localDependency(spec,superDependency)
        self.netDependency(spec)
    end
end
