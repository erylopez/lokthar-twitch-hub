import flatpickr from "flatpickr";
import Choices from "choices.js";
$(document).ready(() => {
  const pickr = flatpickr("#birthday", {
    altInput: true,
    altFormat: "F j",
    dateFormat: "d-m",
  });

  $('#submit-birthday').on('click', () => {
    $('#submit-birthday').attr('disabled', true)
    const birthday = $('#birthday').val();
    const url = $('#birthday').data('endpoint');
    pickr._input.setAttribute('disabled', 'disalbed');

    if (birthday.length > 0) {
      $.ajax({
        url: url,
        type: 'PUT',
        data: {birth_date: birthday, authenticity_token: $('[name="csrf-token"]')[0].content},
        success: function(data) {
          $('.birthday-error').addClass('d-none');
          $('#submit-birthday').removeClass('btn-primary').addClass('btn-success')
          $('#submit-birthday > .btn-text').html("Guardado!")
          $('.birthday-badge').slideUp(700);
        },
        error: function (xhr, ajaxOptions, thrownError) {
          $('#submit-birthday').attr('disabled', null);
          pickr._input.removeAttribute('disabled');
          $('.birthday-error').removeClass('d-none').html("Hubo un error intentado guardar tu cumpleaños, intenta de nuevo o contactanos via discord para reportar el error porfavor.");
        }
      });
    } else {
      $('#submit-birthday').attr('disabled', null);
      pickr._input.removeAttribute('disabled');
      $('.birthday-error').removeClass('d-none').html("Debes ingresar dia y mes de tu cumpleaños");
    }
  });

  const countrySelect = new Choices('#country', {shouldSort: false});

  countrySelect.setChoices(
    [
      {
        label: 'America del Sur',
        id: 1,
        disabled: false,
        choices: [
          { value: 'Argentina', label: 'Argentina'},
          { value: 'Chile', label: 'Chile'},
          { value: 'Bolivia', label: 'Bolivia'},
          { value: 'Brasil', label: 'Brasil'},
          { value: 'Colombia', label: 'Colombia'},
          { value: 'Ecuador', label: 'Ecuador'},
          { value: 'Guyana', label: 'Guyana'},
          { value: 'Paraguay', label: 'Paraguay'},
          { value: 'Perú', label: 'Perú'},
          { value: 'Surinam', label: 'Surinam'},
          { value: 'Uruguay', label: 'Uruguay'},
          { value: 'Venezuela', label: 'Venezuela'},
        ],
      },
      {
        label: 'America Central',
        id: 2,
        disabled: false,
        choices: [
          { value: 'Belice', label: 'Belice' },
          { value: 'Costa', label: 'Costa' },
          { value: 'El', label: 'El' },
          { value: 'Guatemala', label: 'Guatemala' },
          { value: 'Honduras', label: 'Honduras' },
          { value: 'México', label: 'México' },
          { value: 'Nicaragua', label: 'Nicaragua' },
          { value: 'Panamá', label: 'Panamá' },
        ],
      },
      {
        label: 'America del Norte',
        id: 3,
        disabled: false,
        choices: [
          {value: 'Canadá', label: 'Canadá'},
          {value: 'Estados Unidos', label: 'Estados Unidos'},
        ]
      },
      {
        label: 'Europa',
        id: 4,
        disabled: false,
        choices: [
          {value: 'España', label: 'España'},
        ]
      },
      {
        label: 'Caribe',
        id: 5,
        disabled: false,
        choices: [
          {label: 'Antigua y Barbuda', value: 'Antigua y Barbuda'},
          {label: 'Bahamas', value: 'Bahamas'},
          {label: 'Barbados', value: 'Barbados'},
          {label: 'Cuba', value: 'Cuba'},
          {label: 'Dominica', value: 'Dominica'},
          {label: 'Granada', value: 'Granada'},
          {label: 'Haití', value: 'Haití'},
          {label: 'Jamaica', value: 'Jamaica'},
          {label: 'República Dominicana', value: 'República Dominicana'},
          {label: 'San Cristóbal y Nieves', value: 'San Cristóbal y Nieves'},
          {label: 'Santa Lucía', value: 'Santa Lucía'},
          {label: 'San Vicente y las Granadinas', value: 'San Vicente y las Granadinas'},
          {label: 'Trinidad y Tobago', value: 'Trinidad y Tobago'},
        ]
      },
      {
        label: 'Otros',
        id: 6,
        disabled: false,
        choices: [
          {label: 'Otros', value: 'Otros'}
        ]
      }
    ]
  );

  $('#submit-country').on('click', () => {
    $('#submit-country').attr('disabled', true)
    const country = $('#country').val();
    const url = $('#country').data('endpoint');
    countrySelect.disable();

    if (country && country.length > 0) {
      $.ajax({
        url: url,
        type: 'PUT',
        data: {country: country, authenticity_token: $('[name="csrf-token"]')[0].content},
        success: function(data) {
          $('.country-error').addClass('d-none');
          $('#submit-country').removeClass('btn-primary').addClass('btn-success')
          $('#submit-country > .btn-text').html("Guardado!")
          $('.country-badge').slideUp(700);
        },
        error: function (xhr, ajaxOptions, thrownError) {
          $('#submit-country').attr('disabled', null);
          pickr._input.removeAttribute('disabled');
          $('.country-error').removeClass('d-none').html("Hubo un error intentado guardar tu pais, intenta de nuevo o contactanos via discord para reportar el error porfavor.");
        }
      });
    } else {
      $('#submit-country').attr('disabled', null);
      countrySelect.enable();
      $('.country-error').removeClass('d-none').html("Debes ingresar un pais");
    }
  });
})