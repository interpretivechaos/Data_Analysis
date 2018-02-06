function fileName=stripExtensions(fileName)
%STRIPEXTENSIONS Takes a file path/name and removes any and all extensions.
%Useful for handling files with multiple extensions, e.g. raw.kwd
%strippedname=STRIPEXTENSIONS(fileName) removes the path and all extensions
%from fileName.
[path, fileName, extension]=fileparts(fileName);

if ~strcmp(extension, '')
   %Recursively strip the next extension
   fileName=stripExtensions(fileName);
end

end