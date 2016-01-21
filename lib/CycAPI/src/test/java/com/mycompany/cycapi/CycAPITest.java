/*
 * Copyright 2016 Cycorp, Inc..
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.mycompany.cycapi;

/*
 * #%L
 * File: CycAPITest.java
 * Project: Cyc API
 * %%
 * Copyright (C) 2016 Cycorp, Inc.
 * %%
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * #L%
 */


import com.cyc.session.CycSessionManager;
import com.cyc.session.spi.SessionManager;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Reid
/ */
public class CycAPITest {
    
    public CycAPITest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
        SessionManager sessionMgr = CycSessionManager.getInstance();
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    /*
     * JUMBLE CLUES
     *  
     *
     * jumble clue/1/4/3 turet/2/3 sipeo/2 tafsey/2/6 girheh/2/4/6
     * main
     *
     */

    /**
     * Test of main method, of class CycAPI.
     */
    //@Test
    public void testMain() {
        System.out.println("main");
        String[] args = null;
         
    
         CycAPI.main(args);
        // TODO review the generated test code and remove the default call to fail.
        Assert.assertArrayEquals(args, null);
    }

    /**
     * Test of runExample method, of class CycAPI.
     */
//    @Test
    public void testRunExample() throws Exception {
        System.out.println("runExample");
          CycAPI instance = new CycAPI();
        instance.runExample();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
}
