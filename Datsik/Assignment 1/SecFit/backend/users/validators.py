# Retrieved from https://gist.github.com/mobula/da99e4db843b9ceb3a3f
# Modified to remove ImageValidator since it is not needed for this project.

# @brief
# Performs file upload validation for django.
# with Django 1.7 migrations support (deconstructible)

# @author dokterbob
# @author jrosebr1
# @author mobula

import mimetypes
from os.path import splitext

from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
from django.template.defaultfilters import filesizeformat

from django.utils.deconstruct import deconstructible



@deconstructible
class FileValidator(object):
    """
    Validator for files, checking the size, extension and mimetype.

    Initialization parameters:
        allowed_extensions: iterable with allowed file extensions
            ie. ('txt', 'doc')
        allowed_mimetypes: iterable with allowed mimetypes
            ie. ('image/png', )
        min_size: minimum number of bytes allowed
            ie. 100
        max_size: maximum number of bytes allowed
            ie. 24*1024*1024 for 24 MB

    Usage example::

        MyModel(models.Model):
            myfile = FileField(validators=FileValidator(max_size=24*1024*1024), ...)

    """

    messages = {
        'extension_not_allowed': _("Extension '%(extension)s' not allowed. Allowed extensions are: '%(allowed_extensions)s.'"),
        'mimetype_not_allowed': _("MIME type '%(mimetype)s' is not valid. Allowed types are: %(allowed_mimetypes)s."),
        'min_size':             _('The current file %(size)s, which is too small. The minumum file size is %(allowed_size)s.'),
        'max_size':             _('The current file %(size)s, which is too large. The maximum file size is %(allowed_size)s.')
    }

    mime_message = _("MIME type '%(mimetype)s' is not valid. Allowed types are: %(allowed_mimetypes)s.")
    min_size_message = _('The current file %(size)s, which is too small. The minumum file size is %(allowed_size)s.')
    max_size_message = _('The current file %(size)s, which is too large. The maximum file size is %(allowed_size)s.')

    def __init__(self, *args, **kwargs):
        self.allowed_extensions = kwargs.pop('allowed_extensions', None)
        self.allowed_mimetypes = kwargs.pop('allowed_mimetypes', None)
        self.min_size = kwargs.pop('min_size', 0)
        self.max_size = kwargs.pop('max_size', None)

    def __eq__(self, other):
        return ( isinstance(other, FileValidator)
            and (self.allowed_extensions == other.allowed_extensions)
            and (self.allowed_mimetypes == other.allowed_mimetypes)
            and (self.min_size == other.min_size)
            and (self.max_size == other.max_size)
        )

    def __call__(self, value):
        """
        Check the extension, content type and file size.
        """

        # Check the extension
        ext = splitext(value.name)[1][1:].lower()
        if self.allowed_extensions and not ext in self.allowed_extensions:
            code = 'extension_not_allowed'
            message = self.messages[code]
            params = {
                'extension' : ext,
                'allowed_extensions': ', '.join(self.allowed_extensions)
            }
            raise ValidationError(message=message, code=code, params=params)

        # Check the content type
        mimetype = mimetypes.guess_type(value.name)[0]
        if self.allowed_mimetypes and not mimetype in self.allowed_mimetypes:
            code = 'mimetype_not_allowed'
            message = self.messages[code]
            params = {
                'mimetype': mimetype,
                'allowed_mimetypes': ', '.join(self.allowed_mimetypes)
            }
            raise ValidationError(message=message, code=code, params=params)

        # Check the file size
        filesize = len(value)
        if self.max_size and filesize > self.max_size:
            code = 'max_size'
            message = self.messages[code]
            params = {
                'size': filesizeformat(filesize),
                'allowed_size': filesizeformat(self.max_size)
            }
            raise ValidationError(message=message, code=code, params=params)

        elif filesize < self.min_size:
            code = 'min_size'
            message = self.messages[code]
            params = {
                'size': filesizeformat(filesize),
                'allowed_size': filesizeformat(self.min_size)
            }
            raise ValidationError(message=message, code=code, params=params)
