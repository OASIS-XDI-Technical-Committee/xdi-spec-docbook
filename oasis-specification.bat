@echo off
goto :start

  Configured for 0.6
  
  Windows batch file for publishing an OASIS specification DocBook XML instance

  Assumes three batch files exist in the system:

      xmldtd  input-XML-file

      xslt  input-XML-file  stylesheet-XSL-file  output-file

      xslfo-pdf  input-FO-file  output-PDF-file

  $Id: oasis-specification.bat,v 1.13 2011/11/09 17:56:15 admin Exp $

:start
if a%2 == a goto :error

rem The last of the following set commands is the one engaged
set oasis-ss-dir=http://docs.oasis-open.org/templates/DocBook/spec-0.6/stylesheets/
set oasis-ss-dir=c:/oasis/spec-0.6/stylesheets/

echo Validating instance...
call xmldtd oasis-specification-%1-%2.xml
if %errorlevel% neq 0 goto :done
echo Making offline HTML...
call xslt oasis-specification-%1-%2.xml %oasis-ss-dir%oasis-specification-html-offline.xsl oasis-specification-%1-%2-offline.html
if %errorlevel% neq 0 goto :done
echo Making online HTML...
call xslt oasis-specification-%1-%2.xml %oasis-ss-dir%oasis-specification-html.xsl nul automatic-output-filename=yes
if %errorlevel% neq 0 goto :done
echo Making relative HTML...
call xslt oasis-specification-%1-%2.xml %oasis-ss-dir%oasis-specification-html.xsl oasis-specification-%1-%2-relative.html html.stylesheet=css/oasis-spec.css oasis.logo=OASISLogo.jpg
if %errorlevel% neq 0 goto :done
echo Making XSL-FO US...
call xslt oasis-specification-%1-%2.xml %oasis-ss-dir%oasis-specification-fo-us.xsl nul automatic-output-filename=yes
if %errorlevel% neq 0 goto :done
echo Making PDF US...
call xslfo-pdf oasis-specification-%1-%2.fo oasis-specification-%1-%2-us.pdf
if %errorlevel% neq 0 goto :done
echo Making XSL-FO A4...
call xslt oasis-specification-%1-%2.xml %oasis-ss-dir%oasis-specification-fo-a4.xsl nul automatic-output-filename=yes
if %errorlevel% neq 0 goto :done
echo Making PDF A4...
call xslfo-pdf oasis-specification-%1-%2.fo oasis-specification-%1-%2.pdf
if %errorlevel% neq 0 goto :done

goto :done

:error
echo Missing version of document as first argument and stage as second argument

:done