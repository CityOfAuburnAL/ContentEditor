(function() {
  var ImageUploader, PDFUploader, PageUploader;

  ImageUploader = (function() {
    ImageUploader.imagePath = 'image.png';

    ImageUploader.imageSize = [600, 174];

    function ImageUploader(dialog) {
      this._dialog = dialog;
      this._dialog.addEventListener('cancel', (function(_this) {
        return function() {
          return _this._onCancel();
        };
      })(this));
      this._dialog.addEventListener('imageuploader.cancelupload', (function(_this) {
        return function() {
          return _this._onCancelUpload();
        };
      })(this));
      this._dialog.addEventListener('imageuploader.clear', (function(_this) {
        return function() {
          return _this._onClear();
        };
      })(this));
      this._dialog.addEventListener('imageuploader.fileready', (function(_this) {
        return function(ev) {
          return _this._onFileReady(ev.detail().file);
        };
      })(this));
      this._dialog.addEventListener('imageuploader.mount', (function(_this) {
        return function() {
          return _this._onMount();
        };
      })(this));
      this._dialog.addEventListener('imageuploader.rotateccw', (function(_this) {
        return function() {
          return _this._onRotateCCW();
        };
      })(this));
      this._dialog.addEventListener('imageuploader.rotatecw', (function(_this) {
        return function() {
          return _this._onRotateCW();
        };
      })(this));
      this._dialog.addEventListener('imageuploader.save', (function(_this) {
        return function() {
          return _this._onSave();
        };
      })(this));
      this._dialog.addEventListener('imageuploader.unmount', (function(_this) {
        return function() {
          return _this._onUnmount();
        };
      })(this));
    }

    ImageUploader.prototype._onCancel = function() {};

    ImageUploader.prototype._onCancelUpload = function() {
      clearTimeout(this._uploadingTimeout);
      return this._dialog.state('empty');
    };

    ImageUploader.prototype._onClear = function() {
      return this._dialog.clear();
    };

    ImageUploader.prototype._onFileReady = function(file) {
      var upload;
      console.log(file);
      this._dialog.progress(0);
      this._dialog.state('uploading');
      upload = (function(_this) {
        return function() {
          var progress;
          progress = _this._dialog.progress();
          progress += 1;
          if (progress <= 100) {
            _this._dialog.progress(progress);
            return _this._uploadingTimeout = setTimeout(upload, 25);
          } else {
            return _this._dialog.populate(ImageUploader.imagePath, ImageUploader.imageSize);
          }
        };
      })(this);
      return this._uploadingTimeout = setTimeout(upload, 25);
    };

    ImageUploader.prototype._onMount = function() {};

    ImageUploader.prototype._onRotateCCW = function() {
      var clearBusy;
      this._dialog.busy(true);
      clearBusy = (function(_this) {
        return function() {
          return _this._dialog.busy(false);
        };
      })(this);
      return setTimeout(clearBusy, 1500);
    };

    ImageUploader.prototype._onRotateCW = function() {
      var clearBusy;
      this._dialog.busy(true);
      clearBusy = (function(_this) {
        return function() {
          return _this._dialog.busy(false);
        };
      })(this);
      return setTimeout(clearBusy, 1500);
    };

    ImageUploader.prototype._onSave = function() {
      var clearBusy;
      this._dialog.busy(true);
      clearBusy = (function(_this) {
        return function() {
          _this._dialog.busy(false);
          return _this._dialog.save(ImageUploader.imagePath, ImageUploader.imageSize, {
            alt: 'Example of bad variable names'
          });
        };
      })(this);
      return setTimeout(clearBusy, 1500);
    };

    ImageUploader.prototype._onUnmount = function() {};

    ImageUploader.createImageUploader = function(dialog) {
      return new ImageUploader(dialog);
    };

    return ImageUploader;

  })();

  window.ImageUploader = ImageUploader;

  PDFUploader = (function() {
    PDFUploader.pdfPath = 'doc.pdf';

    function PDFUploader(dialog) {
      this._dialog = dialog;
      this._dialog.addEventListener('cancel', (function(_this) {
        return function() {
          return _this._onCancel();
        };
      })(this));
      this._dialog.addEventListener('pdfuploader.cancelupload', (function(_this) {
        return function() {
          return _this._onCancelUpload();
        };
      })(this));
      this._dialog.addEventListener('pdfuploader.clear', (function(_this) {
        return function() {
          return _this._onClear();
        };
      })(this));
      this._dialog.addEventListener('pdfuploader.fileready', (function(_this) {
        return function(ev) {
          return _this._onFileReady(ev.detail().file);
        };
      })(this));
      this._dialog.addEventListener('pdfuploader.mount', (function(_this) {
        return function() {
          return _this._onMount();
        };
      })(this));
      this._dialog.addEventListener('pdfuploader.save', (function(_this) {
        return function() {
          return _this._onSave();
        };
      })(this));
      this._dialog.addEventListener('pdfuploader.unmount', (function(_this) {
        return function() {
          return _this._onUnmount();
        };
      })(this));
    }

    PDFUploader.prototype._onCancel = function() {};

    PDFUploader.prototype._onCancelUpload = function() {
      clearTimeout(this._uploadingTimeout);
      return this._dialog.state('empty');
    };

    PDFUploader.prototype._onClear = function() {
      return this._dialog.clear();
    };

    PDFUploader.prototype._onFileReady = function(file) {
      var upload;
      console.log(file);
      this._dialog.progress(0);
      this._dialog.state('uploading');
      upload = (function(_this) {
        return function() {
          var progress;
          progress = _this._dialog.progress();
          progress += 1;
          if (progress <= 100) {
            _this._dialog.progress(progress);
            return _this._uploadingTimeout = setTimeout(upload, 25);
          } else {
            return _this._dialog.populate(PDFUploader.pdfPath);
          }
        };
      })(this);
      return this._uploadingTimeout = setTimeout(upload, 25);
    };

    PDFUploader.prototype._onMount = function() {};

    PDFUploader.prototype._onSave = function() {
      var clearBusy;
      this._dialog.busy(true);
      clearBusy = (function(_this) {
        return function() {
          _this._dialog.busy(false);
          return _this._dialog.save(PDFUploader.pdfPath, {
            alt: 'Example of bad variable names'
          });
        };
      })(this);
      return setTimeout(clearBusy, 1500);
    };

    PDFUploader.prototype._onUnmount = function() {};

    PDFUploader.createPDFUploader = function(dialog) {
      return new PDFUploader(dialog);
    };

    return PDFUploader;

  })();

  window.PDFUploader = PDFUploader;

  PageUploader = (function() {
    PageUploader.pagePath = 'new-page';

    function PageUploader(dialog) {
      this._dialog = dialog;
      if (!this._dialog.addEventListener) {
        return;
      }
      this._dialog.addEventListener('pageuploader.create', (function(_this) {
        return function(ev) {
          return _this._onCreate(ev.detail().name);
        };
      })(this));
    }

    PageUploader.prototype.Create = function(pageName) {
      var upload;
      console.log(pageName);
      this._progress = 0;
      upload = (function(_this) {
        return function() {
          _this._progress += 5;
          if (_this._progress <= 100) {
            return _this._uploadingTimeout = setTimeout(upload, 25);
          } else {
            return _this._dialog.populate(PageUploader.pagePath);
          }
        };
      })(this);
      return this._uploadingTimeout = setTimeout(upload, 25);
    };

    PageUploader.createPageUploader = function(dialog) {
      return new PageUploader(dialog);
    };

    return PageUploader;

  })();

  window.PageUploader = PageUploader;

  window.onload = function() {
    var FIXTURE_TOOLS, editor, req;
    ContentTools.IMAGE_UPLOADER = ImageUploader.createImageUploader;
    ContentTools.PDF_UPLOADER = PDFUploader.createPDFUploader;
    ContentTools.PAGE_UPLOADER = PageUploader.createPageUploader;
    ContentTools.DEFAULT_TOOLS = [['bold', 'italic', 'link', 'align-left', 'align-center', 'align-right'], ['heading', 'subheading', 'paragraph', 'unordered-list', 'ordered-list', 'table', 'indent', 'unindent', 'line-break'], ['image', 'video', 'preformatted'], ['custom-link', 'custom-create'], ['undo', 'redo', 'remove']];
    ContentTools.StylePalette.add([new ContentTools.Style('By-line', 'article__by-line', ['p']), new ContentTools.Style('Caption', 'article__caption', ['p']), new ContentTools.Style('Example', 'example', ['pre']), new ContentTools.Style('Example + Good', 'example--good', ['pre']), new ContentTools.Style('Example + Bad', 'example--bad', ['pre'])]);
    editor = ContentTools.EditorApp.get();
    editor.init('[data-editable], [data-fixture]', 'data-name');
    editor.addEventListener('saved', function(ev) {
      var saved;
      console.log(ev.detail().regions);
      if (Object.keys(ev.detail().regions).length === 0) {
        return;
      }
      editor.busy(true);
      saved = (function(_this) {
        return function() {
          editor.busy(false);
          return new ContentTools.FlashUI('ok');
        };
      })(this);
      return setTimeout(saved, 2000);
    });
    FIXTURE_TOOLS = [['undo', 'redo', 'remove']];
    ContentEdit.Root.get().bind('focus', function(element) {
      var tools;
      if (element.isFixed()) {
        tools = FIXTURE_TOOLS;
      } else {
        tools = ContentTools.DEFAULT_TOOLS;
      }
      if (editor.toolbox().tools() !== tools) {
        return editor.toolbox().tools(tools);
      }
    });
    req = new XMLHttpRequest();
    req.overrideMimeType('application/json');
    req.open('GET', 'https://raw.githubusercontent.com/GetmeUK/ContentTools/master/translations/lp.json', true);
    return req.onreadystatechange = function(ev) {
      var translations;
      if (ev.target.readyState === 4) {
        translations = JSON.parse(ev.target.responseText);
        ContentEdit.addTranslations('lp', translations);
        return ContentEdit.LANGUAGE = 'lp';
      }
    };
  };

}).call(this);
