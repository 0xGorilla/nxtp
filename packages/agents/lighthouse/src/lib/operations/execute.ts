import { createLoggingContext, ExecuteArgs, jsonifyError, NxtpError, RequestContext } from "@connext/nxtp-utils";

import { getOperations } from "../operations";
import { getContext } from "../../lighthouse";

// fee percentage paid to relayer. need to be updated later
export const RELAYER_FEE_PERCENTAGE = "1"; //  1%

/**
 * Router creates a new bid and sends it to auctioneer.
 *
 * @param args - The crosschain xcall params.
 */
export const execute = async (
  args: ExecuteArgs,
  transferId: string,
  _requestContext: RequestContext,
): Promise<void> => {
  const { requestContext, methodContext } = createLoggingContext(execute.name);

  const {
    logger,
    adapters: { contracts },
  } = getContext();
  const { sendToRelayer } = getOperations();

  logger.info("Method start", requestContext, methodContext, { args });

  // Validate Input schema
  // const validateInput = ajv.compile(XTransferSchema);
  // const validInput = validateInput(params);
  // if (!validInput) {
  //   const msg = validateInput.errors?.map((err: any) => `${err.instancePath} - ${err.message}`).join(",");
  //   throw new ParamsInvalid({
  //     paramsError: msg,
  //     params,
  //   });
  // }
  let encodedData = "";
  try {
    encodedData = contracts.connext.encodeFunctionData("execute", [args]);
  } catch (error: any) {
    logger.error("Error encoding execute data", requestContext, methodContext, jsonifyError(error as NxtpError), {
      args,
      transferId,
    });
    return;
  }

  await sendToRelayer(args, encodedData, transferId, requestContext);
};
