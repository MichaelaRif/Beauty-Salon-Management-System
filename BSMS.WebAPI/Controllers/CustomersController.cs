using BSMS.BusinessLayer.Commands;
using BSMS.BusinessLayer.Queries;
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

        // GET api/customers/customer/user-profile
        [HttpGet("customer/user-profile")]
        public async Task<IActionResult> GetCustomerUserProfile()
        {
            var customerProfile = await _mediator.Send(new GetCustomerProfileQuery{});

            return Ok(customerProfile);
        }

        // PUT api/customers/customer/user-profile
        [HttpPut("customer/user-profile")]
        public async Task<IActionResult> UpdateCustomerUserProfile(UpdateCustomerProfileCommand command)
        {
            var updatedCustomerProfile = await _mediator.Send(command);

            return Ok(updatedCustomerProfile);
        }

        // DELETE api/customers/customer
        [HttpDelete("customer")]
        public async Task<IActionResult> DeleteCustomer()
        {
            var command = new DeleteCustomerCommand { };
            await _mediator.Send(command);

            return Ok();
        }

    }
}
