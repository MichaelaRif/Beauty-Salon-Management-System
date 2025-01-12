using BSMS.BusinessLayer.Commands;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/customers")]
    public class CustomersController : ControllerBase
    {
        private readonly IMediator _mediator;

        public CustomersController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // POST api/customers/register
        [HttpPost("register")]
        public async Task<IActionResult> RegisterCustomer()
        {
            var command = new CreateCustomerCommand { };

            var keycloakId = await _mediator.Send(command);

            return Ok();
        }

        // GET api/customers/customer
        [HttpGet("customer")]
        public async Task<IActionResult> GetCustomerByKeycloakId()
        {
            var customer = await _mediator.Send(new GetCustomerByKeycloakIdQuery {});

            return Ok(customer);
        }

        // POST api/customers/preferences
        [HttpPost("preferences")]
        public async Task<IActionResult> CreateCustomerPreferences(CreateCustomerPreferenceCommand command)
        {
            await _mediator.Send(command);

            return Ok();
        }
        }

    }
}
