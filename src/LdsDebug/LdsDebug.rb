module LdsDebug
    def LdsDebug.localDependency(s,superDependency)
        if superDependency.nil?
            s.dependency 'LdsLogger'
            s.dependency 'LdsHttp'
        else 
            s.dependency "#{superDependency}/LdsLogger"
            s.dependency "#{superDependency}/LdsHttp"
        end
    end
    def LdsDebug.netDependency(s)
    end
    def LdsDebug.config(spec,sourcePath,superDependency)
        spec.ios.deployment_target = '9.0'
        spec.source_files = "#{sourcePath}Classes/**/*"
        self.localDependency(spec,superDependency)
        self.netDependency(spec)
    end
end
