function varargout = subsref( obj, s )
%  Class properties and derived properties for spectrumretlayer objects.
%
%  Usage for obj = spectrumretlayer :
%    obj.layer              :  layer structure
%    obj.pinfty             :  discretized surface of unit sphere
%    obj.scattering( sig )  :  scattering cross section (use also obj.sca)
%    obj.farfield(   sig )  :  far fields for given surface charge

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case { 'sca', 'scattering' }
        [ varargout{ 1 : nargout } ] = scattering( obj, s( 2 ).subs{ : } );
      case 'farfield'
        [ varargout{ 1 : nargout } ] = farfield(   obj, s( 2 ).subs{ : } );                       
      otherwise
        varargout{ 1 } = builtin( 'subsref', obj, s );
    end
end
