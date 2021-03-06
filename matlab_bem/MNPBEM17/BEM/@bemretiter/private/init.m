function obj = init( obj, p, varargin )
%  INIT - Initialize iterative BEM solver.
%
%  Usage for obj = bemretiter :
%    obj = init( obj, p,       op, PropertyName, PropertyValue, ... )
%    obj = init( obj, p, [],   op, PropertyName, PropertyValue, ... )
%    obj = init( obj, p, enei, op, PropertyName, PropertyValue, ... )
%  Input
%    p    :  compound of particles (see comparticle)
%    enei :  light wavelength in vacuum
%    op   :  options 
%              additional fields of the option array can be passed as
%              pairs of PropertyName and PropertyValue

%  save particle and outer surface normal
[ obj.p, obj.nvec ] = deal( p, p.nvec );

%  handle calls with and without ENEI
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ enei, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  option structure
obj.op = getbemoptions( { 'iter', 'bemiter' }, varargin{ : } );
%  Green function, set tolerance and maximal rank for low-rank matrices
obj.g = aca.compgreenret( p, varargin{ : }, 'htol', min( obj.op.htol ), 'kmax', max( obj.op.kmax ) );
%  cluster tree for reduction of preconditioner matrices
if isfield( obj.op, 'reduce' )
  obj.rtree = reducetree( obj.g.hmat.tree, obj.op.reduce );
end

%  initialize for given wavelength
if exist( 'enei', 'var' ) && ~isempty( enei )
  obj = subsref( obj, substruct( '()', { enei } ) );
end
